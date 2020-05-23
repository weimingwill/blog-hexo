#!/bin/bash
hexo generate
cp 404.html ./public/
firebase deploy --token "$FIREBASE_TOKEN"