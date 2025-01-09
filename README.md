# snand project

the **snand project** is a self-hosted family blog and media-sharing site designed to replace traditional cms platforms like wordpress.  it leverages modern tools and frameworks to create a customizable, lightweight, and accessible platform for families to share and preserve memories while promoting diy self-hosting solutions.

## objectives

1. **create a customizable blog**:
   - replace wordpress with a more efficient, self-built solution.  
   - serve static content with ease.

2. **support key features**:
   - static content management.  
   - commenting system.  
   - authentication and access control.  
   - image and video handling.  
   - embeds from other sites.

3. **promote self-hosting**:
   - share resources and instructions for self-hosting.  
   - provide a straightforward setup for non-technical users.

4. **learn and demonstrate**:
   - showcase how modern ai and open-source tools simplify self-hosting.  
   - serve as a practical learning project in python and infrastructure development.

## technology stack

### framework
- **django cms**: chosen for its robust features and alignment with project goals.

### deployment
- **docker**: ensures portability and avoids dependency issues.  
- **ansible**: automates server deployment and management and ensures reproducability.

### hosting
- **low-power debian server**:
  - services managed via docker.  
  - traefik for ingress and let's encrypt certificates.  
  - cloudflare for dns and external access.

### integration
- **immich backend**: avoids duplicating assets for photo sharing.

## development workflow

1. **environment setup**:
   - develop using docker containers for consistency.  
   - utilize ansible for deployment scripts.

2. **planned features**:
   - static content as the primary priority.  
   - build a robust commenting system.  
   - incorporate user authentication and access control.  
   - expand support for images, videos, and embeds.

3. **architecture**:
   - django cms serves as the core framework.  
   - keep the project modular and extendable.

## project journey

### initial goals
1. replace wordpress with a custom solution.
2. integrate with existing self-hosted services, like immich for photo-sharing.
3. maintain simplicity and focus on learning while building a practical system.
4. prioritize portability, documentation, and ease of setup using docker and ansible.

### key decisions and milestones
1. **framework selection:** django cms was chosen for its wysiwyg editor and robust features, allowing for customization of css and design.
2. **development approach:**
   - development began with python virtual environments, transitioning to docker containers for production.
   - integration of a containerized postgresql database.
3. **learning and exploration:**
   - explored and evaluated `djangocms-blog`, but ultimately chose to use straight django cms for simplicity and flexibility.
   - gained understanding of dockerized setups through the `djangocms-quickstart` container, which now serves as the foundation for the project.

### current focus
1. **front page recreation:**
   - recreate the wordpress site’s front page style.
   - keep functionality minimal for now, focusing on demonstrating basic capabilities.
2. **example site:**
   - build an example site with django cms to serve as a live tutorial and starting point for others.

## next steps

1. **learn django cms:**
   - read documentation and watch tutorials to understand site-building fundamentals.
   - experiment with django cms features to design the front page and basic layout.
2. **build the example site:**
   - create a basic page using django cms.
   - document the process for reuse and learning purposes.
3. **chamboard integration:**
   - transition chamboard’s api to use django cms as the source of truth.
   - ensure smooth integration with the rest of the snand ecosystem.
4. **immich integration:**
   - after chamboard, integrate an immich instance.
   - use immich apis for image hosting while maintaining a seamless system-wide experience.
5. **expand functionality:**
   - add commenting, authentication, and media embedding features as needed.

## getting started

# this section is not accurate and will be replaced

### prerequisites
- **docker** and **docker compose** installed on your development machine.  
- basic familiarity with python, docker, and linux environments.

### setup instructions
1. clone this repository:
   ```bash
   git clone https://github.com/your-username/snand.git
   cd snand
   ```

2. build and start the containers:
   ```bash
   docker-compose up -d
   ```

3. access the application:
   - development environment: `http://localhost`  
   - production environment: configure domain and traefik settings.

### deployment
use the provided ansible playbooks to deploy the project to your server:
```bash
ansible-playbook -i inventory deploy.yml
```

## documentation
visit the [documentation folder](docs/) for setup guides, user instructions, and self-hosting resources.

## license
this project is open-source under the [mit license](LICENSE).
