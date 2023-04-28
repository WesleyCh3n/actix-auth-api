all:

auth:
	curl -v -X POST localhost:8080/auth \
		-H "Content-Type: application/json" \
		-d '{"email": "wesley@wesley.com", "password": "1234"}'

station:
	curl -v -H "Authorization: Bearer ${TOKEN}" localhost:8080/api/station
	curl -v -H "Authorization: Bearer ${TOKEN}" localhost:8080/api/station/123
