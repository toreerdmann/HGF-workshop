#!/bin/bash
git archive --format=zip --prefix=hgfToolBox_$1/ --output=Archive/hgfToolBox_$1.zip $1
