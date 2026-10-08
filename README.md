ANTIVIRUS PROJECT

This project is a small antivirus made with bash scripts. One script watches a folder. When something in the folder changes, it checks every file. If a file looks dangerous, it is moved to a separate quarantine folder. Another script lets me look at the quarantined files and decide to bring a file back or delete it for good.


WHAT IS IN THE PROJECT

antivirusd.sh is the main script. It watches the folder and scans it. You run it with the folder to watch, the quarantine folder, and the number of seconds to wait between checks.

restore.sh is the script for looking at quarantined files. You run it with the folder to watch and the quarantine folder.

Makefile lets you start both scripts with short commands. It also creates the quarantine folder if it is missing.

A file is treated as dangerous if its extension is on the bad list, or if one of the bad words is found inside it. The watched folder should only have files in it, no folders.


FOLDER STRUCTURE

    antivirus
        antivirusd.sh
        restore.sh
        Makefile
        README.md
        .gitignore

These are made while the program runs and are not saved in git:

    testdir - the folder being watched
    quarantine - where bad files are kept
    directory-info.last - the old list of the folder
    directory-info.new - the new list of the folder


WHAT YOU NEED FIRST

You need Ubuntu. Bash and the basic commands (ls, diff, grep, cp, mv, rm) come already installed. You also need make and git. Install them with:

    sudo apt update
    sudo apt install make git


HOW TO RUN IT

Step 1. Download the project and go inside it:

    git clone https://github.com/mazenzanatyy-bit/antivirus.git
    cd antivirus
    chmod +x antivirusd.sh restore.sh

Step 2. Make a folder to watch and put a test file in it:

    mkdir testdir
    echo "hello" > testdir/a.exe

Step 3. Start the antivirus:

    make run

It scans right away. After that it checks the folder every 5 seconds and only scans again if something changed. When it finds a bad file, it prints the file name followed by "is malicious and it is DELETED", copies the file to quarantine, and removes it from testdir. Press Ctrl+C to stop it.

Step 4. To look at the quarantined files, run this (not at the same time as the antivirus):

    make restore

Choose a file by its number, then choose one of these:

1 = put the file back, it was not really bad
2 = delete the file for good
3 = leave it and go back to the list

Type 0 to quit. When quarantine is empty, it prints "No malicious files to review."

To use different folders or a different time:

    make run DIR=myfolder MAL_DIR=myquarantine INTERVAL=10
    make restore DIR=myfolder MAL_DIR=myquarantine


WHERE THE BAD LISTS ARE

Both lists are at the top of antivirusd.sh.

bad_ext is the list of bad extensions: exe, bat, vbs, scr, ps1.

bad_words is the list of bad words: virus, trojan, malware, worm, ransomware.
