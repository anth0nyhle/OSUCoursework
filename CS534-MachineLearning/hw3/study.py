#!/usr/bin/env python

from __future__ import print_function
from __future__ import division
from collections import defaultdict
import sys
from math import log

startsym, stopsym = "<s>", "</s>"


def readfile(filename):
    for line in open(filename): # go thru data file line by line
        wordtags = map(lambda x: x.rsplit("/", 1), line.split()) # mapping and separating words and tags
        yield [w for w, t in wordtags], [t for w, t in wordtags] # (word_seq, tag_seq) pair


def mle(filename):
    twfreq = defaultdict(lambda: defaultdict(int)) # create dictionary for tag, word frequency
    ttfreq = defaultdict(lambda: defaultdict(int)) # create dicitionary for tag, tag frequency
    tagfreq = defaultdict(int) # create dictionary for frequency of different tags
    dictionary = defaultdict(set) # create dictionary for words and tags based on frequencies

    for words, tags in readfile(filename):
        last = startsym # = "<s>"
        tagfreq[last] += 1 # frequency of tag
        for word, tag in zip(words, tags) + [(stopsym, stopsym)]: # go thru each word, tag w/ start, stop indicators
            # if tag == "VBP": tag = "VB" # +1 smoothing
            twfreq[tag][word] += 1 # tag, word frequency; emission; freq of words for different tags
            ttfreq[last][tag] += 1 # prev tag, and curr tag frequency; transition; freq of tags for different tags
            dictionary[word].add(tag) # words and possible tags
            tagfreq[tag] += 1 # different tag frequency
            last = tag

    # print(tagfreq)
    # print(twfreq)
    # print(ttfreq)

    model = defaultdict(float) # create dictionary of weights for each feature pair
    num_tags = len(tagfreq) # number of different tags
    for tag, freq in tagfreq.iteritems():
        logfreq = log(freq) # log of the frequency
        for word, f in twfreq[tag].iteritems():
            model[tag, word] = log(f) - logfreq # calculate weights for tag, word pairs
        logfreq2 = log(freq + num_tags)
        for t in tagfreq: # all tags
            model[tag, t] = log(ttfreq[tag][t] + 1) - logfreq2 # +1 smoothing; calculate weights for tag, tag pairs

    return dictionary, model


def decode(words, dictionary, model):
    def backtrack(i, tag):
        if i == 0:
            return []
        return backtrack(i - 1, back[i][tag]) + [tag]

    words = [startsym] + words + [stopsym]

    best = defaultdict(lambda: defaultdict(lambda: float("-inf")))
    best[0][startsym] = 1
    back = defaultdict(dict)

    # print " ".join("%s/%s" % wordtag for wordtag in zip(words, tags)[1:-1])
    for i, word in enumerate(words[1:], 1):
        for tag in dictionary[word]:
            for prev in best[i - 1]:
                score = best[i - 1][prev] + model[prev, tag] + model[tag, word]
                if score > best[i][tag]:
                    best[i][tag] = score
                    back[i][tag] = prev
                    # print i, word, dictionary[word], best[i]
    # print best[len(words)-1][stopsym]
    mytags = backtrack(len(words) - 1, stopsym)[:-1]
    # print " ".join("%s/%s" % wordtag for wordtag in mywordtags)
    return mytags


def test(filename, dictionary, model):
    errors = tot = 0
    for words, tags in readfile(filename):
        mytags = decode(words, dictionary, model)
        errors += sum(t1 != t2 for (t1, t2) in zip(tags, mytags))
        tot += len(words)

    return errors / tot


if __name__ == "__main__":
    trainfile, devfile = sys.argv[1:3]

    dictionary, model = mle(trainfile)

    # for words, tags in readfile(trainfile):
    #     mytags = decode(words, dictionary, model)
    #     print(mytags)

    # print(dictionary)

    print("train_err {0:.2%}".format(test(trainfile, dictionary, model)))
    print("dev_err {0:.2%}".format(test(devfile, dictionary, model)))