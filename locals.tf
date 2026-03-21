locals {
  tarantino_characters = [
    "jules", "vincent", "mia", "butch",
    "marsellus", "beatrix", "oren", "vernita",
    "budd", "elle", "django", "schultz",
    "candie", "broomhilda", "aldo", "shosanna",
    "landa", "stiglitz", "jackie", "ordell",
    "max", "stuntman", "zoe", "daisy",
    "warren", "mannix", "bob", "domergue",
    "cliff", "rick"
  ]

  container_keys = keys(var.lxc_containers)

  name_assignments = {
    for idx, key in local.container_keys :
    key => random_shuffle.character.result[idx]
  }
}