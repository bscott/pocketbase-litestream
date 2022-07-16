## Prerequisites

To test this locally, you'll need to have an S3-compatible store to connect to. Please see the Litestream Guides to get set up on your preferred object store.

You'll also need to update the replica URL in etc/litestream.yml in this repository to your appropriate object store.

You'll also need to set your object store credentials in your shell environment:

export LITESTREAM_ACCESS_KEY_ID=XXX
export LITESTREAM_SECRET_ACCESS_KEY=XXX
export REPLICA_URL=s3://YOURBUCKETNAME/db

Building & running the container

You can build the application with the following command:

docker build -t myapp .

Once the image is built, you can run it with the following command. Be sure to change the REPLICA_URL variable to point to your bucket.

```
docker run \
  -p 8090:8090 \
  -v ${PWD}:/pb_data \
  -e REPLICA_URL=s3://YOURBUCKETNAME/db \
  -e LITESTREAM_ACCESS_KEY_ID \
  -e LITESTREAM_SECRET_ACCESS_KEY \
  myapp
```

Let's break down the options one-by-one:

    -p 8080:8080—maps the container's port 8080 to the host machine's port 8080 so you can access the application's web server.

    -v ${PWD}:/data—mounts a volume from your current directory on the host to the /pb_data directory inside the container.

    -e REPLICA_URL=...—sets an environment variable for your replica. This is used by the startup script to restore the database from a replica if it doesn't exist and it is used in the Litestream configuration file.

    -e LITESTREAM_ACCESS_KEY_ID & -e LITESTREAM_SECRET_ACCESS_KEY—passes through your current environment variables for your S3 credentials to the container. You can also use AWS_ACCESS_KEY_ID and AWS_SECRET_ACCESS_KEY instead.
