# dnans.org is snand.org's test playground

# present state - kinda working actually.  

## still a fair bit of work until it's production ready but so far it's proving to be more effective than the .sh scripts.

dnans is [snand's](https://www.snand.org) dev environment. this is purely a place to learn and play and test out features for the main snand.org.  currently this is my Ansible playground where I'm exploring potential replacements for my script based setup.

**disclaimer**:  
this directory is experimental and contains work-in-progress crap.  it's not intended for public use, but if you find anything here useful, feel free...

---

## current focus

- ~~setting up a basic Ansible project structure.~~
- automating server configurations, including:
  - ~~installing essential packages (`sudo`, `docker`, `samba`, `nfs`).~~
  - managing system services.
  - setting up persistent mounts using UUIDs.
  - configuring SMB shares
- installing docker projects
- ~~traefik~~
 - cloudflare
 - Wordpress
 - immich


## future enhancements

- versioning for .env and compose files
  - .env skipped if it exists, need logic for checking version or something in case of future change

---

## Versioning

| Version   | Status        | Description                      |
|-----------|---------------|----------------------------------|
| `v0.0.3`  | wip | rolled it back into snand.org's repo, better to keep together. |
| `v0.0.2`  | wip | Docker, traefik and wordpress working. |
| `v0.0.1`  | wip | Initial setup, basic configurations. |
| `v0.0.x`  | begin progress | Iterative improvements and testing. |