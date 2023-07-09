# Base image for this application
FROM python:3.9.13-alpine3.16

WORKDIR /app

COPY requirements.txt .

#pip will install all the dependencies inside the image

RUN pip install -r requirements.txt

#Copy code to /app/src in the container
COPY src src

#Expose port 5000 for this application
EXPOSE 5000

# Every interval 30s this healthcheck command runs, timeout wait for 30s 
# timeout within 30s not run failed
# start-period initial delay before healthcheck commands are run 30s
# after 5 failed requests this health check gets failed and the container is marked as unhealthy
HEALTHCHECK --interval=30s --timeout=30s --start-period=30s --retries=5 \ 
            CMD curl -f http://localhost:5000/health || exit 1
# if curl fails exit 1

CMD ["flask","--app","./src/app.py","run", "--host=0.0.0.0", "--port=5000"]