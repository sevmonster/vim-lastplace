# vim-lastplace
Intelligently reopen files where you left off.

- Author  :  Greg Dietsche
- Web Page: http://www.gregd.org/
- License : MIT
- Version : 1.0.0

## Introduction

Intelligently reopen files where you left off. With the option to
ignore specific file types. By default git, svn, and mercurial
commit messages are ignored.

You can configure what file types to ignore by setting g:lastplace_ignore.
For example to only ignore git and snv commit messages try this in your vimrc:

        let g:lastplace_ignore = "gitcommit,svn"

## About

Get the latest version and/or report a bug on GitHub:
        http://github.com/dietsche/vim-lastplace