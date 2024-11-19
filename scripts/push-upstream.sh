#!/bin/bash
echo "We are on ${HOSTNAME} so let's push!"
git push origin master
git push --tags
git push --follow-tags
