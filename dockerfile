
# docker build .
# docker run -p 3030:3000 feff1b386df0
# docker run -p yourPcPort:dockerPort :imagename
# docker tag 1234567890 vkvik434321/node3000:latest
# docker push vkvik434321/node3000:latest
# docker cp 75fd:/app C:\Rsystems
FROM node:14-alpine
WORKDIR /app
COPY . .
RUN npm install
EXPOSE 3000

CMD ["npm", "run" , "start"]