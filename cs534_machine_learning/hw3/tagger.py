#!/usr/bin/env python

from __future__ import print_function
from __future__ import division
from collections import defaultdict
import sys
from math import log

startsym, stopsym = "<s>", "</s>"


def readfile(filename):
    for line in open(filename):
        wordtags = map(lambda x: x.rsplit("/", 1), line.split())
        yield [w for w, t in wordtags], [t for w, t in wordtags]  # (word_seq, tag_seq) pair
        # print([w for w, t in wordtags], [t for w, t in wordtags])


def mle(filename):  # Max Likelihood Estimation of HMM
    twfreq = defaultdict(lambda: defaultdict(int))
    ttfreq = defaultdict(lambda: defaultdict(int))
    tagfreq = defaultdict(int)
    dictionary = defaultdict(set)

    for words, tags in readfile(filename):
        last = startsym
        tagfreq[last] += 1
        for word, tag in zip(words, tags) + [(stopsym, stopsym)]:
            # if tag == "VBP": tag = "VB" # +1 smoothing
            twfreq[tag][word] += 1
            ttfreq[last][tag] += 1
            dictionary[word].add(tag)
            tagfreq[tag] += 1
            last = tag

    # print(twfreq)
    # print(len(twfreq))

    model = defaultdict(float)
    num_tags = len(tagfreq)
    for tag, freq in tagfreq.iteritems():
        logfreq = log(freq)
        for word, f in twfreq[tag].iteritems():
            model[tag, word] = log(f) - logfreq
        logfreq2 = log(freq + num_tags)
        for t in tagfreq:  # all tags
            model[tag, t] = log(ttfreq[tag][t] + 1) - logfreq2  # +1 smoothing

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

    # print " ".join("%s/%s" % wordtag for wordtag in zip(words,tags)[1:-1])
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

    print("train_err {0:.2%}".format(test(trainfile, dictionary, model)))
    print("dev_err {0:.2%}".format(test(devfile, dictionary, model)))

    # print("DICTIONARY")
    # print(dictionary)

    # print("MODEL")
    # print(model)