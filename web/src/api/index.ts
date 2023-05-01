import axios from "axios";

export default axios.create({
  baseURL: "http://localhost:8080",
});

export const apiPrivate = axios.create({
  baseURL: "http://localhost:8080",
  headers: { "Content-Type": "application/json" },
  // withCredentials: true,
});

export interface ApiResponse<T> {
  status: String;
  length: number;
  results: T[];
}
