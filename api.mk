all:
	curl -s -X POST localhost:8080/auth \
		-H "Content-Type: application/json" \
		-d '{"name": "wesley", "password": "1234"}'

	curl -v -H "Authorization: Bearer ${TOKEN}" localhost:8080/api/station
	curl -v -H "Authorization: Bearer ${TOKEN}" localhost:8080/api/station/123
