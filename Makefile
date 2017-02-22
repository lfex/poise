PROJECT = poise
ROOT_DIR = $(shell pwd)
REPO = $(shell git config --get remote.origin.url)
LFE = _build/dev/lib/lfe/bin/lfe

include resources/make/code.mk
include resources/make/docs.mk
