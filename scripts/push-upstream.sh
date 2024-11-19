#!/bin/bash
echo "We are on ${HOSTNAME} so let's push!"
git push origin main
git push --tags
git push --follow-tags
