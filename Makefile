.PHONY: *

export NAME?=$(shell echo $(shell basename $(shell pwd)) | awk '{print tolower($0)}')

$(NAME): image push

image:
	@docker-compose build $(NAME)

push:
	@docker-compose push $(NAME)

