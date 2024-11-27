module.exports.handler = async (event) => {
  return {
    statusCode: 200,
    body: JSON.stringify(
      {
        message: "Go Serverless, Blow Architecture! Implementing Clean Arch with AWS LAmbda Function",
        input: event,
      },
      null,
      2
    ),
  };
};