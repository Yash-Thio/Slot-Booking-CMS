module.exports = ({ env }) => ({
  upload: {
    config: {
      provider: "aws-s3", // For community providers pass the full package name (e.g. provider: 'strapi-provider-upload-google-cloud-storage')
      providerOptions: {
        s3Options: {
          credentials: {
            accessKeyId: env("AWS_ACCESS_KEY_ID"),
            secretAccessKey: env("AWS_ACCESS_SECRET"),
          },
          region: "us-east-2",
          params: {
            ACL: env("AWS_ACL", "public-read"), // 'private' if you want to make the uploaded files private
            Bucket: "lovethyself-cms",
          },
        },
      },
    },
  },
});
