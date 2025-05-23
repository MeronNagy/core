Feature: Collections support
  In order to retrieve large collections of resources
  As a client software developer
  I need to retrieve paged collections respecting the Hydra specification

  @createSchema
  Scenario: Retrieve an empty collection
    When I send a "GET" request to "/dummies"
    Then the response status code should be 200
    And the response should be in JSON
    And the header "Content-Type" should be equal to "application/ld+json; charset=utf-8"
    And the JSON should be valid according to this schema:
    """
    {
      "type": "object",
      "properties": {
        "@context": {"pattern": "^/contexts/Dummy$"},
        "@id": {"pattern": "^/dummies$"},
        "@type": {"pattern": "^hydra:Collection$"},
        "hydra:totalItems": {"type":"number", "maximum": 0},
        "hydra:member": {
          "type": "array",
          "maxItems": 0
        },
        "hydra:search": {}
      },
      "additionalProperties": false
    }
    """

  Scenario: Retrieve the first page of a collection
    Given there are 30 dummy objects
    And I send a "GET" request to "/dummies"
    Then the response status code should be 200
    And the response should be in JSON
    And the header "Content-Type" should be equal to "application/ld+json; charset=utf-8"
    And the JSON should be valid according to this schema:
    """
    {
      "type": "object",
      "properties": {
        "@context": {"pattern": "^/contexts/Dummy$"},
        "@id": {"pattern": "^/dummies$"},
        "@type": {"pattern": "^hydra:Collection$"},
        "hydra:totalItems": {"type":"number", "maximum": 30},
        "hydra:member": {
          "type": "array",
          "items": {
            "type": "object",
            "properties": {
              "@id": {
                "oneOf": [
                  {"pattern": "^/dummies/1$"},
                  {"pattern": "^/dummies/2$"},
                  {"pattern": "^/dummies/3$"}
                ]
              }
            }
          },
          "maxItems": 3
        },
        "hydra:view": {
          "type": "object",
          "properties": {
            "@id": {"pattern": "^/dummies\\?page=1$"},
            "@type": {"pattern": "^hydra:PartialCollectionView$"},
            "hydra:first": {"pattern": "^/dummies\\?page=1$"},
            "hydra:last": {"pattern": "^/dummies\\?page=10$"},
            "hydra:next": {"pattern": "^/dummies\\?page=2$"}
          }
        }
      }
    }
    """

  Scenario: Retrieve a page of a collection
    When I send a "GET" request to "/dummies?page=7"
    Then the response status code should be 200
    And the response should be in JSON
    And the header "Content-Type" should be equal to "application/ld+json; charset=utf-8"
    And the JSON should be valid according to this schema:
    """
    {
      "type": "object",
      "properties": {
        "@context": {"pattern": "^/contexts/Dummy$"},
        "@id": {"pattern": "^/dummies$"},
        "@type": {"pattern": "^hydra:Collection$"},
        "hydra:totalItems": {"type":"number", "maximum": 30},
        "hydra:member": {
          "type": "array",
          "items": {
            "type": "object",
            "properties": {
              "@id": {
                "oneOf": [
                  {"pattern": "^/dummies/19$"},
                  {"pattern": "^/dummies/20$"},
                  {"pattern": "^/dummies/21$"}
                ]
              }
            }
          },
          "maxItems": 3
        },
        "hydra:view": {
          "type": "object",
          "properties": {
            "@id": {"pattern": "^/dummies\\?page=7$"},
            "@type": {"pattern": "^hydra:PartialCollectionView$"},
            "hydra:first": {"pattern": "^/dummies\\?page=1$"},
            "hydra:last": {"pattern": "^/dummies\\?page=10$"},
            "hydra:next": {"pattern": "^/dummies\\?page=8$"},
            "hydra:previous": {"pattern": "^/dummies\\?page=6$"}
          }
        }
      }
    }
    """

  Scenario: Retrieve the last page of a collection
    When I send a "GET" request to "/dummies?page=10"
    Then the response status code should be 200
    And the response should be in JSON
    And the header "Content-Type" should be equal to "application/ld+json; charset=utf-8"
    And the JSON should be valid according to this schema:
    """
    {
      "type": "object",
      "properties": {
        "@context": {"pattern": "^/contexts/Dummy$"},
        "@id": {"pattern": "^/dummies$"},
        "@type": {"pattern": "^hydra:Collection$"},
        "hydra:totalItems": {"type":"number", "maximum": 30},
        "hydra:member": {
          "type": "array",
          "items": {
            "type": "object",
            "properties": {
              "@id": {
                "oneOf": [
                  {"pattern": "^/dummies/28$"},
                  {"pattern": "^/dummies/29$"},
                  {"pattern": "^/dummies/30$"}
                ]
              }
            }
          },
          "maxItems": 3
        },
        "hydra:view": {
          "type": "object",
          "properties": {
            "@id": {"pattern": "^/dummies\\?page=10$"},
            "@type": {"pattern": "^hydra:PartialCollectionView$"},
            "hydra:first": {"pattern": "^/dummies\\?page=1$"},
            "hydra:last": {"pattern": "^/dummies\\?page=10$"},
            "hydra:previous": {"pattern": "^/dummies\\?page=9$"}
          }
        },
        "hydra:search": {}
      },
      "additionalProperties": false
    }
    """

  @!mongodb
  Scenario: Enable the partial pagination client side
    When I send a "GET" request to "/dummies?page=7&partial=1"
    Then the response status code should be 200
    And the response should be in JSON
    And the header "Content-Type" should be equal to "application/ld+json; charset=utf-8"
    And the JSON should be valid according to this schema:
    """
    {
      "type": "object",
      "properties": {
        "@context": {"pattern": "^/contexts/Dummy$"},
        "@id": {"pattern": "^/dummies$"},
        "@type": {"pattern": "^hydra:Collection$"},
        "hydra:totalItems": {"type":"number", "maximum": 30},
        "hydra:member": {
          "type": "array",
          "items": {
            "type": "object",
            "properties": {
              "@id": {
                "oneOf": [
                  {"pattern": "^/dummies/19$"},
                  {"pattern": "^/dummies/20$"},
                  {"pattern": "^/dummies/21$"}
                ]
              }
            }
          },
          "maxItems": 3
        },
        "hydra:view": {
          "type": "object",
          "properties": {
            "@id": {"pattern": "^/dummies\\?partial=1&page=7$"},
            "@type": {"pattern": "^hydra:PartialCollectionView$"},
            "hydra:next": {"pattern": "^/dummies\\?partial=1&page=8$"},
            "hydra:previous": {"pattern": "^/dummies\\?partial=1&page=6$"}
          },
          "required": ["@id", "@type", "hydra:next", "hydra:previous"],
          "additionalProperties": false,
          "maxProperties": 4
        }
      },
      "required": ["@context", "@id", "@type", "hydra:member", "hydra:view", "hydra:search"],
      "maxProperties": 6
    }
    """

  Scenario: Disable the pagination client side
    When I send a "GET" request to "/dummies?pagination=0"
    Then the response status code should be 200
    And the response should be in JSON
    And the header "Content-Type" should be equal to "application/ld+json; charset=utf-8"
    And the JSON should be valid according to this schema:
    """
    {
      "type": "object",
      "properties": {
        "@context": {"pattern": "^/contexts/Dummy$"},
        "@id": {"pattern": "^/dummies$"},
        "@type": {"pattern": "^hydra:Collection$"},
        "hydra:totalItems": {"type":"number", "minimum": 30},
        "hydra:member": {
          "type": "array",
          "minItems": 30
        },
        "hydra:search": {}
      },
      "additionalProperties": false
    }
    """

  Scenario: Change the number of element by page client side
    When I send a "GET" request to "/dummies?page=2&itemsPerPage=10"
    Then the response status code should be 200
    And the response should be in JSON
    And the header "Content-Type" should be equal to "application/ld+json; charset=utf-8"
    And the JSON should be valid according to this schema:
    """
    {
      "type": "object",
      "properties": {
        "@context": {"pattern": "^/contexts/Dummy$"},
        "@id": {"pattern": "^/dummies$"},
        "@type": {"pattern": "^hydra:Collection$"},
        "hydra:totalItems": {"type":"number", "maximum": 30},
        "hydra:member": {
          "type": "array",
          "minItems": 10,
          "maxItems": 10
        },
        "hydra:view": {
          "type": "object",
          "properties": {
            "@id": {"pattern": "^/dummies\\?itemsPerPage=10&page=2$"},
            "@type": {"pattern": "^hydra:PartialCollectionView$"},
            "hydra:first": {"pattern": "^/dummies\\?itemsPerPage=10&page=1$"},
            "hydra:last": {"pattern": "^/dummies\\?itemsPerPage=10&page=3$"},
            "hydra:previous": {"pattern": "^/dummies\\?itemsPerPage=10&page=1$"},
            "hydra:next": {"pattern": "^/dummies\\?itemsPerPage=10&page=3$"}
          }
        },
        "hydra:search": {}
      },
      "additionalProperties": false
    }
    """

  @!mongodb
  @php8
  Scenario: Change the number of element by page client side with v3, attributes and PHP8. Defaults (max 40) should not override resource attribute (max 30)
    Given there are 80 pagination entities
    When I send a "GET" request to "/pagination_entities?page=2&itemsPerPage=40"
    Then the response status code should be 200
    And the response should be in JSON
    And the header "Content-Type" should be equal to "application/ld+json; charset=utf-8"
    And the JSON should be valid according to this schema:
    """
    {
      "type": "object",
      "properties": {
        "@context": {"pattern": "^/contexts/PaginationEntity"},
        "@id": {"pattern": "^/pagination_entities"},
        "@type": {"pattern": "^hydra:Collection$"},
        "hydra:totalItems": {"type":"number", "maximum": 80},
        "hydra:member": {
          "type": "array",
          "minItems": 30,
          "maxItems": 30
        },
        "hydra:view": {
          "type": "object",
          "properties": {
            "@id": {"pattern": "^/pagination_entities\\?itemsPerPage=40&page=2$"},
            "@type": {"pattern": "^hydra:PartialCollectionView$"},
            "hydra:first": {"pattern": "^/pagination_entities\\?itemsPerPage=40&page=1$"},
            "hydra:last": {"pattern": "^/pagination_entities\\?itemsPerPage=40&page=3$"},
            "hydra:previous": {"pattern": "^/pagination_entities\\?itemsPerPage=40&page=1$"},
            "hydra:next": {"pattern": "^/pagination_entities\\?itemsPerPage=40&page=3$"}
          }
        },
        "hydra:search": {}
      },
      "additionalProperties": false
    }
    """

  Scenario: Test presence of next
    When I send a "GET" request to "/dummies?page=3"
    Then the response status code should be 200
    And the response should be in JSON
    And the header "Content-Type" should be equal to "application/ld+json; charset=utf-8"
    And the JSON should be valid according to this schema:
    """
    {
      "@id":"/dummies?page=3",
      "@type":"hydra:PartialCollectionView",
      "hydra:first":"/dummies?page=1",
      "hydra:last":"/dummies?page=10",
      "hydra:previous":"/dummies?page=2",
      "hydra:next":"/dummies?page=4"
    }
    """

  Scenario: Filter with exact match
    When I send a "GET" request to "/dummies?id=8"
    Then the response status code should be 200
    And the response should be in JSON
    And the header "Content-Type" should be equal to "application/ld+json; charset=utf-8"
    And the JSON should be valid according to this schema:
    """
    {
      "type": "object",
      "properties": {
        "@context": {"pattern": "^/contexts/Dummy$"},
        "@id": {"pattern": "^/dummies$"},
        "@type": {"pattern": "^hydra:Collection$"},
        "hydra:totalItems": {"type":"number", "maximum": 1},
        "hydra:member": {
          "type": "array",
          "items": {
            "type": "object",
            "properties": {
              "@id": {"pattern": "^/dummies/8$"}
            }
          },
          "maxItems": 1
        },
        "hydra:view": {
          "type": "object",
          "properties": {
            "@id": {"pattern": "^/dummies\\?id=8$"},
            "@type": {"pattern": "^hydra:PartialCollectionView$"}
          }
        },
        "hydra:search": {}
      },
      "additionalProperties": false
    }
    """

  Scenario: Filter with a raw URL
    When I send a "GET" request to "/dummies?id=%2fdummies%2f8"
    Then the response status code should be 200
    And the response should be in JSON
    And the header "Content-Type" should be equal to "application/ld+json; charset=utf-8"
    And the JSON should be valid according to this schema:
    """
    {
      "type": "object",
      "properties": {
        "@context": {"pattern": "^/contexts/Dummy$"},
        "@id": {"pattern": "^/dummies$"},
        "@type": {"pattern": "^hydra:Collection$"},
        "hydra:totalItems": {"type":"number", "maximum": 1},
        "hydra:member": {
          "type": "array",
          "items": {
            "type": "object",
            "properties": {
              "@id": {"pattern": "^/dummies/8$"}
            }
          },
          "maxItems": 1
        },
        "hydra:view": {
          "type": "object",
          "properties": {
            "@id": {"pattern": "^/dummies\\?id=%2Fdummies%2F8$"},
            "@type": {"pattern": "^hydra:PartialCollectionView$"}
          }
        },
        "hydra:search": {}
      },
      "additionalProperties": false
    }
    """

  Scenario: Filter with non-exact match
    When I send a "GET" request to "/dummies?name=Dummy%20%238"
    Then the response status code should be 200
    And the response should be in JSON
    And the header "Content-Type" should be equal to "application/ld+json; charset=utf-8"
    And the JSON should be valid according to this schema:
    """
    {
      "type": "object",
      "properties": {
        "@context": {"pattern": "^/contexts/Dummy$"},
        "@id": {"pattern": "^/dummies$"},
        "@type": {"pattern": "^hydra:Collection$"},
        "hydra:totalItems": {"type":"number", "maximum": 1},
        "hydra:member": {
          "type": "array",
          "items": {
            "type": "object",
            "properties": {
              "@id": {"pattern": "^/dummies/8$"}
            }
          },
          "maxItems": 1
        },
        "hydra:view": {
          "type": "object",
          "properties": {
            "@id": {"pattern": "^/dummies\\?name=Dummy%20%238$"},
            "@type": {"pattern": "^hydra:PartialCollectionView$"}
          }
        },
        "hydra:search": {}
      },
      "additionalProperties": false
    }
    """

  @createSchema
  Scenario: Allow passing 0 to `itemsPerPage`
    When I send a "GET" request to "/dummies?itemsPerPage=0"
    Then the response status code should be 200
    And the response should be in JSON
    And the header "Content-Type" should be equal to "application/ld+json; charset=utf-8"
    And the JSON should be valid according to this schema:
    """
    {
      "type": "object",
      "properties": {
        "@context": {"pattern": "^/contexts/Dummy$"},
        "@id": {"pattern": "^/dummies$"},
        "@type": {"pattern": "^hydra:Collection$"},
        "hydra:totalItems": {"type":"number", "maximum": 30},
        "hydra:member": {
          "type": "array",
          "minItems": 0,
          "maxItems": 0
        },
        "hydra:view": {
          "type": "object",
          "properties": {
            "@id": {"pattern": "^/dummies\\?itemsPerPage=0$"},
            "@type": {"pattern": "^hydra:PartialCollectionView$"},
            "hydra:first": {"pattern": "^/dummies\\?itemsPerPage=0&page=1$"},
            "hydra:last": {"pattern": "^/dummies\\?itemsPerPage=0&page=1$"},
            "hydra:previous": {"pattern": "^/dummies\\?itemsPerPage=0&page=1$"},
            "hydra:next": {"pattern": "^/dummies\\?itemsPerPage=0&page=1$"}
          }
        },
        "hydra:search": {}
      },
      "additionalProperties": false
    }
    """

    When I send a "GET" request to "/dummies?itemsPerPage=0&page=2"
    Then the response status code should be 400
    And the JSON node "detail" should be equal to "Page should not be greater than 1 if limit is equal to 0"

  Scenario: Cursor-based pagination with an empty collection
    When I send a "GET" request to "/so_manies"
    Then the response status code should be 200
    And the response should be in JSON
    And the header "Content-Type" should be equal to "application/ld+json; charset=utf-8"
    And the JSON should be valid according to this schema:
    """
    {
      "type": "object",
      "properties": {
        "@context": {"pattern": "^/contexts/SoMany$"},
        "@id": {"pattern": "^/so_manies$"},
        "@type": {"pattern": "^hydra:Collection"},
        "hydra:view": {
          "type": "object",
          "properties": {
            "@id": {"pattern": "^/so_manies$"},
            "@type": {"pattern": "^hydra:PartialCollectionView$"}
          },
          "additionalProperties": false
        },
        "hydra:member": {
          "type": "array"
        }
      }
    }
    """

  @createSchema
  Scenario: Cursor-based pagination with ranged items
    Given there are 10 of these so many objects
    When I send a "GET" request to "/so_manies?order[id]=desc"
    Then the response status code should be 200
    And the response should be in JSON
    And the header "Content-Type" should be equal to "application/ld+json; charset=utf-8"
    And the JSON should be valid according to this schema:
    """
    {
      "type": "object",
      "properties": {
        "@context": {"pattern": "^/contexts/SoMany$"},
        "@id": {"pattern": "^/so_manies$"},
        "@type": {"pattern": "^hydra:Collection"},
        "hydra:view": {
          "type": "object",
          "properties": {
            "@id": {"pattern": "^/so_manies\\?order%5Bid%5D=desc$"},
            "@type": {"pattern": "^hydra:PartialCollectionView$"},
            "hydra:previous": {"pattern": "^/so_manies\\?order%5Bid%5D=desc&id%5Bgt%5D=10$"},
            "hydra:next": {"pattern": "^/so_manies\\?order%5Bid%5D=desc&id%5Blt%5D=8$"}
          },
          "additionalProperties": false
        },
        "hydra:member": {
          "type": "array",
          "items": {
            "type": "object",
            "properties": {
              "@id": {
                "oneOf": [
                  {"pattern": "^/so_manies/8$"},
                  {"pattern": "^/so_manies/9$"},
                  {"pattern": "^/so_manies/10$"}
                ]
              }
            }
          },
          "minItems": 3
        }
      }
    }
    """

  @createSchema
  Scenario: Cursor-based pagination with range filtered items
    Given there are 10 of these so many objects
    When I send a "GET" request to "/so_manies?order[id]=desc&id[gt]=10"
    Then the response status code should be 200
    And the response should be in JSON
    And the header "Content-Type" should be equal to "application/ld+json; charset=utf-8"
    And the JSON should be valid according to this schema:
    """
    {
      "type": "object",
      "properties": {
        "@context": {"pattern": "^/contexts/SoMany$"},
        "@id": {"pattern": "^/so_manies$"},
        "@type": {"pattern": "^hydra:Collection"},
        "hydra:member": {
          "type": "array",
          "maxItems": 0
        },
        "hydra:view": {
          "type": "object",
          "properties": {
            "@id": {"pattern": "^/so_manies\\?id%5Bgt%5D=10&order%5Bid%5D=desc$"},
            "@type": {"pattern": "^hydra:PartialCollectionView$"},
            "hydra:previous": {"pattern": "^/so_manies\\?id%5Bgt%5D=13&order%5Bid%5D=desc$"},
            "hydra:next": {"pattern": "^/so_manies\\?id%5Blt%5D=10&order%5Bid%5D=desc$"}
          },
          "additionalProperties": false
        }
      }
    }
    """

  Scenario: Hydra collection without prefix
    When I send a "GET" request to "/no_hydra_prefixes"
    Then the response status code should be 200
    And the response should be in JSON
    And the header "Content-Type" should be equal to "application/ld+json; charset=utf-8"
    And the JSON node "totalItems" should exist
    And the JSON node "member" should exist
