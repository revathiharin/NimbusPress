#!/bin/bash
sudo yum install -y stress-ng
stress-ng --cpu 4 --timeout 300s