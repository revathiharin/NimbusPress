#!/bin/bash
sudo yum install -y stress-ng
stress-ng --cpu 4 --timeout 300s

stress-ng --cpu 8 --timeout 3000s