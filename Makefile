# Generate and serve docs
docs:
	@forge doc --build
	@open http://localhost:4000
	@forge doc --serve --port 4000
