@routing @bicycle @turn_penalty
Feature: Turn Penalties

    Background:
        Given the profile "bicycle"
        Given a grid size of 200 meters


    Scenario: Bicycle - Turn penalties on cyclability
        Given the profile file
        """
        functions = require('bicycle')
        function initialize(profile)
          profile.weight_name = 'cyclability'
          return profile
        end
        table.insert(functions.initialize,initialize)
        return functions
        """

        Given the node map
            """
            a--b-----c
               |
               |
               d

            e--------f-----------g
                  /
                /
              /
            h
            """

        And the ways
            | nodes | highway     |
            | abc   | residential |
            | bd    | residential |
            | efg   | residential |
            | fh    | residential |

        When I route I should get
            | from | to | distance  | weight | #                                         |
            | a    | c  | 900m +- 1 | 216    | Going straight has no penalties           |
            | a    | d  | 900m +- 1 | 220.2  | Turning right had penalties               |
            | e    | g  | 2100m +- 4| 503.9  | Going straght has no penalties            |
            | e    | h  | 2100m +- 4| 515.1  | Turn sharp right has even higher penalties|

