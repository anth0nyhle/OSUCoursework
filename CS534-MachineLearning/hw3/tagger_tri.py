#!/usr/bin/env python

from __future__ import division
from collections import defaultdict
import sys
from math import log

startsym, stopsym = "<s>", "</s>"


def readfile_tri(filename):
    for line in open(filename):
        wordtags = map(lambda x: x.rsplit("/", 1), line.split())
        yield [w for w, t in wordtags], [t for w, t in wordtags]  # (word_seq, tag_seq) pair
        # print([w for w, t in wordtags], [t for w, t in wordtags])


def mle_tri(filename):  # Max Likelihood Estimation of HMM
    twfreq = defaultdict(lambda: defaultdict(int))
    ttfreq = defaultdict(lambda: defaultdict(int))

    tttfreq = defaultdict(lambda: defaultdict(int))
    ttwfreq = defaultdict(lambda: defaultdict(int))
    # twwfreq = defaultdict(lambda: defaultdict(int))

    tagfreq = defaultdict(int)
    # tag2freq = defaultdict(int)
    dictionary = defaultdict(set)

    for words, tags in readfile_tri(filename):
        last = startsym
        last_last = startsym
        # last_word = None
        tagfreq[last] += 1
        # tag2freq[last_last] += 1
        for word, tag in zip(words, tags) + [(stopsym, stopsym)]:
            # if tag == "VBP": tag = "VB" # +1 smoothing
            twfreq[tag][word] += 1
            ttfreq[last][tag] += 1
            tttfreq[last_last, last][tag] += 1
            ttwfreq[last, tag][word] += 1
            # twwfreq[tag, last_word][word] += 1
            dictionary[word].add(tag)
            tagfreq[tag] += 1
            # tag2freq[last] += 1
            last_last = last
            last = tag
            # last_word = word

    # print(tagfreq)
    # print(tag2freq)
    # print(twfreq)
    # print(ttfreq)
    # print(tttfreq)
    # print(ttwfreq)
    # print(twwfreq)
    # print(len(ttwfreq))
    # print(len(tttfreq))

    model = defaultdict(float)
    num_tags = len(tagfreq)
    for tag, freq in tagfreq.iteritems():
        # print(tag, freq)
        logfreq = log(freq) # tag prob
        for word, f in twfreq[tag].iteritems():
            # print(word, f)
            model[tag, word] = log(f) - logfreq # word prob given tag

        logfreq2 = log(freq + num_tags)
        for t, t_freq in tagfreq.iteritems():  # all tags
            # print(ttfreq[tag][t])
            model[tag, t] = log(ttfreq[tag][t] + 1) - logfreq2  # +1 smoothing
            # print(model.keys())
            # print(t)
            # print(t_freq)
            # print(freq)
            for t2, t2_freq in tagfreq.iteritems():
                model[tag, t, t2] = log(tttfreq[tag, t][t2] + 1) - logfreq2
                # print(tag, t, t2)

    return dictionary, model


def decode_tri(words, dictionary, model):
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
                for prev_prev in best[i - 2]:
                    score = best[i - 1][prev] + model[prev, tag] + model[tag, word] + model[prev_prev, prev, tag]
                if score > best[i][tag]:
                    best[i][tag] = score
                    back[i][tag] = prev
                    # print i, word, dictionary[word], best[i]
    # print best[len(words)-1][stops]
    mytags = backtrack(len(words) - 1, stopsym)[:-1]
    # print " ".join("%s/%s" % wordtag for wordtag in mywordtags)

    # print(best)
    # print(len(best))
    # print(back)
    # print(len(back))

    return mytags


def test_tri(filename, dictionary, model):
    errors = tot = 0
    for words, tags in readfile_tri(filename):
        mytags = decode_tri(words, dictionary, model)
        errors += sum(t1 != t2 for (t1, t2) in zip(tags, mytags))
        tot += len(words)

    return errors / tot


if __name__ == "__main__":
    trainfile, devfile = sys.argv[1:3]

    dictionary_tri, model_tri = mle_tri(trainfile)

    # print(model)

    print("train_err {0:.2%}".format(test_tri(trainfile, dictionary_tri, model_tri)))
    print("dev_err {0:.2%}".format(test_tri(devfile, dictionary_tri, model_tri)))