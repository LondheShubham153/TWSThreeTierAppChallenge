#!/bin/bash

aws ecr-public get-login-password --region us-east-1 | docker login --username AWS --password-stdin public.ecr.aws/ALIAS_INFO
docker tag three-tier-frontend:latest public.ecr.aws/ALIAS_INFO/three-tier-frontend:latest
docker push public.ecr.aws/ALIAS_INFO/three-tier-frontend:latest
echo Frontend Image Pushed Successfully 		 
aws ecr-public get-login-password --region us-east-1 | docker login --username AWS --password-stdin public.ecr.aws/ALIAS_INFO
docker tag three-tier-backend:latest public.ecr.aws/ALIAS_INFO/three-tier-backend:latest
docker push public.ecr.aws/ALIAS_INFO/three-tier-backend:latest
echo "Backend Image Pushed Successfully