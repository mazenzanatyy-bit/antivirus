DIR = testdir
MAL_DIR = quarantine
INTERVAL = 5

.PHONY: all setup run restore

all: run

setup:
	mkdir -p $(MAL_DIR)

run: setup
	./antivirusd.sh $(DIR) $(MAL_DIR) $(INTERVAL)

restore: setup
	./restore.sh $(DIR) $(MAL_DIR)
