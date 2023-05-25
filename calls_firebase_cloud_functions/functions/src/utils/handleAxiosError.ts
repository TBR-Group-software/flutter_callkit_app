import { AxiosError } from "axios";
import * as functions from "firebase-functions";

export const handleAxiosError = (error: AxiosError) => {
  if (error.response) {
    functions.logger.error(
      error.response.data,
      error.response.status,
      error.response.headers
    );
  } else if (error.request) {
    functions.logger.error(error.request);
  } else {
    functions.logger.error(error.message);
  }
  functions.logger.error(error.config);
};
