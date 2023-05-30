# base image
FROM node:14-alpine
MAINTAINER henry achu

# set working directory
WORKDIR /app

# copy app dependencies
COPY package*.json ./

# install app dependencies
RUN npm install

# copy app source code
COPY . .

# expose port
EXPOSE 3000

# start app
CMD ["npm", "start"]
