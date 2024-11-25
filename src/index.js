module.exports.handler = async (event) => {
  return {
    statusCode: 200,
    body: JSON.stringify(
      {
        message: "Go Serverless, Blow Architecture! Implementing clean architecture with serverless features",
        input: event,
      },
      null,
      2
    ),
  };
};