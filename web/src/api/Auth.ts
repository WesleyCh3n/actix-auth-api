import api, { apiPrivate } from ".";

interface AuthResponse {
  "status": string;
  "user": string;
  "jwt-token": string;
}

export const GetAuth = (email: string, password: string) => {
  return apiPrivate.post<AuthResponse>("/auth", { email, password });
};

export const RemoveAuth = () => api.delete("/auth");
