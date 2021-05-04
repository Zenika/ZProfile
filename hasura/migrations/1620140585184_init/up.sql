CREATE TABLE "public"."User"("email" text NOT NULL, "name" text NOT NULL, "picture" text NOT NULL, PRIMARY KEY ("email") );

CREATE EXTENSION IF NOT EXISTS pgcrypto;
CREATE TABLE "public"."Skill"("id" uuid NOT NULL DEFAULT gen_random_uuid(), "name" text NOT NULL UNIQUE, "categoryId" uuid NOT NULL, PRIMARY KEY ("id") );

CREATE EXTENSION IF NOT EXISTS pgcrypto;
CREATE TABLE "public"."Topic"("id" uuid NOT NULL DEFAULT gen_random_uuid(),  "name" text NOT NULL UNIQUE, PRIMARY KEY ("id") );

CREATE TABLE "public"."UserSkill"("userEmail" text NOT NULL, "skillId" UUID NOT NULL, "level" integer NOT NULL DEFAULT 1, "created_at" date NOT NULL DEFAULT now(), PRIMARY KEY ("userEmail","skillId","created_at") , FOREIGN KEY ("userEmail") REFERENCES "public"."User"("email") ON UPDATE cascade ON DELETE cascade, FOREIGN KEY ("skillId") REFERENCES "public"."Skill"("id") ON UPDATE restrict ON DELETE restrict);

alter table "public"."UserSkill" add constraint "UserSkill_level_between_1_and_5" check (level >= 1 AND level <= 5);

CREATE TABLE "public"."TechnicalAppetite"("userEmail" text NOT NULL, "skillId" uuid NOT NULL, "created_at" date NOT NULL DEFAULT now(), "level" integer NOT NULL DEFAULT 1, PRIMARY KEY ("userEmail","skillId","created_at") , FOREIGN KEY ("userEmail") REFERENCES "public"."User"("email") ON UPDATE cascade ON DELETE cascade, FOREIGN KEY ("skillId") REFERENCES "public"."Skill"("id") ON UPDATE restrict ON DELETE restrict, CONSTRAINT "TechnicalAppetite_level_between_1_and_5" CHECK (level >= 1 AND level <= 5));

CREATE EXTENSION IF NOT EXISTS pgcrypto;
CREATE TABLE "public"."Agency"("name" text NOT NULL, PRIMARY KEY ("name") );

CREATE TABLE "public"."UserAgency"("userEmail" Text NOT NULL, "agency" text NOT NULL, "created_at" date NOT NULL DEFAULT now(), PRIMARY KEY ("userEmail", "created_at") , FOREIGN KEY ("userEmail") REFERENCES "public"."User"("email") ON UPDATE cascade ON DELETE cascade, FOREIGN KEY ("agency") REFERENCES "public"."Agency"("name") ON UPDATE restrict ON DELETE restrict);

CREATE TABLE "public"."UserTopic"("userEmail" text NOT NULL, "topicId" uuid NOT NULL, "created_at" date NOT NULL DEFAULT now(), PRIMARY KEY ("userEmail","topicId","created_at") , FOREIGN KEY ("userEmail") REFERENCES "public"."User"("email") ON UPDATE restrict ON DELETE restrict, FOREIGN KEY ("topicId") REFERENCES "public"."Topic"("id") ON UPDATE restrict ON DELETE restrict);

CREATE EXTENSION IF NOT EXISTS pgcrypto;
CREATE TABLE "public"."Category"("id" uuid NOT NULL DEFAULT gen_random_uuid(), "label" text NOT NULL, "x" text NOT NULL, "y" text NOT NULL, "color" text NOT NULL, "index" integer NOT NULL UNIQUE, PRIMARY KEY ("id") );

alter table "public"."Skill"
           add constraint "Skill_categoryId_fkey"
           foreign key ("categoryId")
           references "public"."Category"
           ("id") on update restrict on delete restrict;



INSERT INTO public."Agency" VALUES 
('Paris'),
('Nantes'),
('Singapore'),
('Bordeaux'),
('Brest'),
('Montreal'),
('Grenoble'),
('Lyon'),
('Rennes'),
('Lille');

INSERT INTO public."Category" VALUES
('89780de3-4a4c-40c2-bcdf-b5d15a48437a', 'languages-and-frameworks', 'left', 'top', 'yellow', 1),
('06420261-3e78-4a91-bc6a-1a52cad5d6a1', 'platforms', 'right', 'top', 'violet', 2),
('c3341edb-3c1f-4e3d-bf89-8e795eb13690', 'tools', 'left' ,'bot', 'blue', 3),
('89f5e9a5-5ce6-416c-bed9-dd736546aa7f', 'technics-and-methods', 'right', 'bot', 'cyan', 4);

INSERT INTO public."Topic" VALUES
('71c8f42c-7182-444d-8133-3a3a52ae7912', 'Frontend'),
('16198ae7-40bb-4fcd-ae5d-ce371902dce2', 'Backend'),
('5a83e55d-22f2-428a-a5e2-effade6b6be5', 'Agilité'),
('b53a5cdb-6269-4965-ae5b-f42c9611664f', 'Maker'),
('817e3dae-01da-446a-920b-a3a5a9f57bea', 'Réseau'),
('7e8e6f07-7844-4c1f-aa91-1dda49555ee3', 'Web'),
('eb4edee0-9351-4fce-b04f-acbee63634b0', 'Security'),
('c42d872f-227e-49ce-8a97-2af8aa021fbd', 'Microservices'),
('6be68073-0f12-42bc-9835-07f8e81ea4a3', 'Network'),
('2117fd9e-bda8-4b0a-b1f1-6ea68bca3443', 'Ops'),
('7ee06efb-f337-4541-b160-10e35cd5b574', 'DevOps'),
('5451823f-965c-40e7-85db-05ff8c7a370d', 'IA'),
('fa4af642-a890-4966-9224-2c607807ef68', 'Data'),
('c80dbcaa-b6d5-42fb-b375-0bb3146fcbbe', 'Mobile');


INSERT INTO public."Skill" VALUES
(DEFAULT, '.NET', '89780de3-4a4c-40c2-bcdf-b5d15a48437a'),
(DEFAULT, '.NET Core', '89780de3-4a4c-40c2-bcdf-b5d15a48437a'),
(DEFAULT, 'ATDD', '89f5e9a5-5ce6-416c-bed9-dd736546aa7f'),
(DEFAULT, 'AWS', '06420261-3e78-4a91-bc6a-1a52cad5d6a1'),
(DEFAULT, 'Accessibilité', '89f5e9a5-5ce6-416c-bed9-dd736546aa7f'),
(DEFAULT, 'Account Management', '89f5e9a5-5ce6-416c-bed9-dd736546aa7f'),
(DEFAULT, 'Agile Coaching', '89f5e9a5-5ce6-416c-bed9-dd736546aa7f'),
(DEFAULT, 'Agilité', '89f5e9a5-5ce6-416c-bed9-dd736546aa7f'),
(DEFAULT, 'Android', '89780de3-4a4c-40c2-bcdf-b5d15a48437a'),
(DEFAULT, 'Anglais 🇬🇧', '89780de3-4a4c-40c2-bcdf-b5d15a48437a'),
(DEFAULT, 'Angular', '89780de3-4a4c-40c2-bcdf-b5d15a48437a'),
(DEFAULT, 'Angular 7', '89780de3-4a4c-40c2-bcdf-b5d15a48437a'),
(DEFAULT, 'Angular 8', '89780de3-4a4c-40c2-bcdf-b5d15a48437a'),
(DEFAULT, 'Angular 8+', '89780de3-4a4c-40c2-bcdf-b5d15a48437a'),
(DEFAULT, 'Angular 9', '89780de3-4a4c-40c2-bcdf-b5d15a48437a'),
(DEFAULT, 'AngularJS', '89780de3-4a4c-40c2-bcdf-b5d15a48437a'),
(DEFAULT, 'Ansible', 'c3341edb-3c1f-4e3d-bf89-8e795eb13690'),
(DEFAULT, 'Apache Pulsar', 'c3341edb-3c1f-4e3d-bf89-8e795eb13690'),
(DEFAULT, 'Azure', '06420261-3e78-4a91-bc6a-1a52cad5d6a1'),
(DEFAULT, 'BDD', '89f5e9a5-5ce6-416c-bed9-dd736546aa7f'),
(DEFAULT, 'BackboneJS', '89780de3-4a4c-40c2-bcdf-b5d15a48437a'),
(DEFAULT, 'Bash', '89780de3-4a4c-40c2-bcdf-b5d15a48437a'),
(DEFAULT, 'Bootstrap', '89780de3-4a4c-40c2-bcdf-b5d15a48437a'),
(DEFAULT, 'C', '89780de3-4a4c-40c2-bcdf-b5d15a48437a'),
(DEFAULT, 'C#', '89780de3-4a4c-40c2-bcdf-b5d15a48437a'),
(DEFAULT, 'C++', '89780de3-4a4c-40c2-bcdf-b5d15a48437a'),
(DEFAULT, 'CI CD', '89f5e9a5-5ce6-416c-bed9-dd736546aa7f'),
(DEFAULT, 'CQRS', '89f5e9a5-5ce6-416c-bed9-dd736546aa7f'),
(DEFAULT, 'CSS', '89780de3-4a4c-40c2-bcdf-b5d15a48437a'),
(DEFAULT, 'Camel', '89780de3-4a4c-40c2-bcdf-b5d15a48437a'),
(DEFAULT, 'Cassandra', 'c3341edb-3c1f-4e3d-bf89-8e795eb13690'),
(DEFAULT, 'Chaos Engineering', '89f5e9a5-5ce6-416c-bed9-dd736546aa7f'),
(DEFAULT, 'Clean Code', '89f5e9a5-5ce6-416c-bed9-dd736546aa7f'),
(DEFAULT, 'Clean architecture', '89f5e9a5-5ce6-416c-bed9-dd736546aa7f'),
(DEFAULT, 'Clever Cloud', '06420261-3e78-4a91-bc6a-1a52cad5d6a1'),
(DEFAULT, 'Clojure', '89780de3-4a4c-40c2-bcdf-b5d15a48437a'),
(DEFAULT, 'Cloud', '06420261-3e78-4a91-bc6a-1a52cad5d6a1'),
(DEFAULT, 'Cloud Functions', '06420261-3e78-4a91-bc6a-1a52cad5d6a1'),
(DEFAULT, 'Coaching Craft', '89f5e9a5-5ce6-416c-bed9-dd736546aa7f'),
(DEFAULT, 'Coaching Devops', '89f5e9a5-5ce6-416c-bed9-dd736546aa7f'),
(DEFAULT, 'Coaching agile', '89f5e9a5-5ce6-416c-bed9-dd736546aa7f'),
(DEFAULT, 'Coaching professionnel', '89f5e9a5-5ce6-416c-bed9-dd736546aa7f'),
(DEFAULT, 'Code Review', '89f5e9a5-5ce6-416c-bed9-dd736546aa7f'),
(DEFAULT, 'Communication Non Violente', '89f5e9a5-5ce6-416c-bed9-dd736546aa7f'),
(DEFAULT, 'Container', '06420261-3e78-4a91-bc6a-1a52cad5d6a1'),
(DEFAULT, 'Continuous Deployment', '89f5e9a5-5ce6-416c-bed9-dd736546aa7f'),
(DEFAULT, 'Continuous Integration', '89f5e9a5-5ce6-416c-bed9-dd736546aa7f'),
(DEFAULT, 'Craftsmanship', '89f5e9a5-5ce6-416c-bed9-dd736546aa7f'),
(DEFAULT, 'Cucumber', '89780de3-4a4c-40c2-bcdf-b5d15a48437a'),
(DEFAULT, 'Cypress', '89780de3-4a4c-40c2-bcdf-b5d15a48437a'),
(DEFAULT, 'D3JS', '89780de3-4a4c-40c2-bcdf-b5d15a48437a'),
(DEFAULT, 'DDD', '89f5e9a5-5ce6-416c-bed9-dd736546aa7f'),
(DEFAULT, 'Dart', '89780de3-4a4c-40c2-bcdf-b5d15a48437a'),
(DEFAULT, 'Dask', '89780de3-4a4c-40c2-bcdf-b5d15a48437a'),
(DEFAULT, 'Data Science', '89f5e9a5-5ce6-416c-bed9-dd736546aa7f'),
(DEFAULT, 'Datadog', '06420261-3e78-4a91-bc6a-1a52cad5d6a1'),
(DEFAULT, 'Dataviz', '89f5e9a5-5ce6-416c-bed9-dd736546aa7f'),
(DEFAULT, 'Deno', '89780de3-4a4c-40c2-bcdf-b5d15a48437a'),
(DEFAULT, 'Design', '89f5e9a5-5ce6-416c-bed9-dd736546aa7f'),
(DEFAULT, 'Design Patterns', '89f5e9a5-5ce6-416c-bed9-dd736546aa7f'),
(DEFAULT, 'Design Sprint', '89f5e9a5-5ce6-416c-bed9-dd736546aa7f'),
(DEFAULT, 'Design System', '89f5e9a5-5ce6-416c-bed9-dd736546aa7f'),
(DEFAULT, 'Design Thinking', '89f5e9a5-5ce6-416c-bed9-dd736546aa7f'),
(DEFAULT, 'DevSecOps', '89f5e9a5-5ce6-416c-bed9-dd736546aa7f'),
(DEFAULT, 'Devops', '89f5e9a5-5ce6-416c-bed9-dd736546aa7f'),
(DEFAULT, 'DialogFlow', '89780de3-4a4c-40c2-bcdf-b5d15a48437a'),
(DEFAULT, 'Docker', 'c3341edb-3c1f-4e3d-bf89-8e795eb13690'),
(DEFAULT, 'Dual-track agile', '89f5e9a5-5ce6-416c-bed9-dd736546aa7f'),
(DEFAULT, 'ELK', '06420261-3e78-4a91-bc6a-1a52cad5d6a1'),
(DEFAULT, 'Elastic Observability', 'c3341edb-3c1f-4e3d-bf89-8e795eb13690'),
(DEFAULT, 'Elastic Stack', 'c3341edb-3c1f-4e3d-bf89-8e795eb13690'),
(DEFAULT, 'ElasticSearch', 'c3341edb-3c1f-4e3d-bf89-8e795eb13690'),
(DEFAULT, 'Electron', '89780de3-4a4c-40c2-bcdf-b5d15a48437a'),
(DEFAULT, 'Elixir', '89780de3-4a4c-40c2-bcdf-b5d15a48437a'),
(DEFAULT, 'Elm', '89780de3-4a4c-40c2-bcdf-b5d15a48437a'),
(DEFAULT, 'EmberJS', '89780de3-4a4c-40c2-bcdf-b5d15a48437a'),
(DEFAULT, 'Espagnol 🇪🇸', '89780de3-4a4c-40c2-bcdf-b5d15a48437a'),
(DEFAULT, 'Event Sourcing', '89f5e9a5-5ce6-416c-bed9-dd736546aa7f'),
(DEFAULT, 'Expo', '06420261-3e78-4a91-bc6a-1a52cad5d6a1'),
(DEFAULT, 'ExpressJS', '89780de3-4a4c-40c2-bcdf-b5d15a48437a'),
(DEFAULT, 'Extreme Programming', '89f5e9a5-5ce6-416c-bed9-dd736546aa7f'),
(DEFAULT, 'Facilitation', '89f5e9a5-5ce6-416c-bed9-dd736546aa7f'),
(DEFAULT, 'Facilitation graphique', '89f5e9a5-5ce6-416c-bed9-dd736546aa7f'),
(DEFAULT, 'Figma', 'c3341edb-3c1f-4e3d-bf89-8e795eb13690'),
(DEFAULT, 'Firebase', '06420261-3e78-4a91-bc6a-1a52cad5d6a1'),
(DEFAULT, 'Flutter', '89780de3-4a4c-40c2-bcdf-b5d15a48437a'),
(DEFAULT, 'Formation', '89f5e9a5-5ce6-416c-bed9-dd736546aa7f'),
(DEFAULT, 'Frontend', '89f5e9a5-5ce6-416c-bed9-dd736546aa7f'),
(DEFAULT, 'GCP', '06420261-3e78-4a91-bc6a-1a52cad5d6a1'),
(DEFAULT, 'GatsbyJS', '89780de3-4a4c-40c2-bcdf-b5d15a48437a'),
(DEFAULT, 'Gestion d''équipe', '89f5e9a5-5ce6-416c-bed9-dd736546aa7f'),
(DEFAULT, 'Gestion de projet', '89f5e9a5-5ce6-416c-bed9-dd736546aa7f'),
(DEFAULT, 'Git', 'c3341edb-3c1f-4e3d-bf89-8e795eb13690'),
(DEFAULT, 'Github', '06420261-3e78-4a91-bc6a-1a52cad5d6a1'),
(DEFAULT, 'Github actions', '06420261-3e78-4a91-bc6a-1a52cad5d6a1'),
(DEFAULT, 'Gitlab CI', '06420261-3e78-4a91-bc6a-1a52cad5d6a1'),
(DEFAULT, 'Go', '89780de3-4a4c-40c2-bcdf-b5d15a48437a'),
(DEFAULT, 'GraalVM', '06420261-3e78-4a91-bc6a-1a52cad5d6a1'),
(DEFAULT, 'Gradle', 'c3341edb-3c1f-4e3d-bf89-8e795eb13690'),
(DEFAULT, 'Grafana', 'c3341edb-3c1f-4e3d-bf89-8e795eb13690'),
(DEFAULT, 'GraphQL', '89780de3-4a4c-40c2-bcdf-b5d15a48437a'),
(DEFAULT, 'Green IT', '89f5e9a5-5ce6-416c-bed9-dd736546aa7f'),
(DEFAULT, 'HTML', '89780de3-4a4c-40c2-bcdf-b5d15a48437a'),
(DEFAULT, 'Haskell', '89780de3-4a4c-40c2-bcdf-b5d15a48437a'),
(DEFAULT, 'Helm', 'c3341edb-3c1f-4e3d-bf89-8e795eb13690'),
(DEFAULT, 'Hibernate', '89780de3-4a4c-40c2-bcdf-b5d15a48437a'),
(DEFAULT, 'Host Leadership', '89f5e9a5-5ce6-416c-bed9-dd736546aa7f'),
(DEFAULT, 'IA', '89f5e9a5-5ce6-416c-bed9-dd736546aa7f'),
(DEFAULT, 'Infrastructure As Code', '89f5e9a5-5ce6-416c-bed9-dd736546aa7f'),
(DEFAULT, 'Innovation game', '89f5e9a5-5ce6-416c-bed9-dd736546aa7f'),
(DEFAULT, 'Intégration continue', '89f5e9a5-5ce6-416c-bed9-dd736546aa7f'),
(DEFAULT, 'Ionic', '89780de3-4a4c-40c2-bcdf-b5d15a48437a'),
(DEFAULT, 'Istio', '06420261-3e78-4a91-bc6a-1a52cad5d6a1'),
(DEFAULT, 'Italien 🇮🇹', '89780de3-4a4c-40c2-bcdf-b5d15a48437a'),
(DEFAULT, 'JPA', '89780de3-4a4c-40c2-bcdf-b5d15a48437a'),
(DEFAULT, 'JSF', '89780de3-4a4c-40c2-bcdf-b5d15a48437a'),
(DEFAULT, 'JSP', '89780de3-4a4c-40c2-bcdf-b5d15a48437a'),
(DEFAULT, 'JUnit', '89780de3-4a4c-40c2-bcdf-b5d15a48437a'),
(DEFAULT, 'JUnit 5', '89780de3-4a4c-40c2-bcdf-b5d15a48437a'),
(DEFAULT, 'JVM', '06420261-3e78-4a91-bc6a-1a52cad5d6a1'),
(DEFAULT, 'JamStack', '06420261-3e78-4a91-bc6a-1a52cad5d6a1'),
(DEFAULT, 'Java ≤7', '89780de3-4a4c-40c2-bcdf-b5d15a48437a'),
(DEFAULT, 'Java ≥8', '89780de3-4a4c-40c2-bcdf-b5d15a48437a'),
(DEFAULT, 'Javascript', '89780de3-4a4c-40c2-bcdf-b5d15a48437a'),
(DEFAULT, 'Jenkins', '06420261-3e78-4a91-bc6a-1a52cad5d6a1'),
(DEFAULT, 'Jest', '89780de3-4a4c-40c2-bcdf-b5d15a48437a'),
(DEFAULT, 'Jira', '06420261-3e78-4a91-bc6a-1a52cad5d6a1'),
(DEFAULT, 'Joomla', '06420261-3e78-4a91-bc6a-1a52cad5d6a1'),
(DEFAULT, 'Kafka', '06420261-3e78-4a91-bc6a-1a52cad5d6a1'),
(DEFAULT, 'Kafka Ops', '06420261-3e78-4a91-bc6a-1a52cad5d6a1'),
(DEFAULT, 'Kafka Streams', '06420261-3e78-4a91-bc6a-1a52cad5d6a1'),
(DEFAULT, 'Kanban', '89f5e9a5-5ce6-416c-bed9-dd736546aa7f'),
(DEFAULT, 'Kotest', '89780de3-4a4c-40c2-bcdf-b5d15a48437a'),
(DEFAULT, 'Kotlin', '89780de3-4a4c-40c2-bcdf-b5d15a48437a'),
(DEFAULT, 'KsqlDB', '06420261-3e78-4a91-bc6a-1a52cad5d6a1'),
(DEFAULT, 'Ktor', 'c3341edb-3c1f-4e3d-bf89-8e795eb13690'),
(DEFAULT, 'Kubeflow', 'c3341edb-3c1f-4e3d-bf89-8e795eb13690'),
(DEFAULT, 'Kubernetes', '06420261-3e78-4a91-bc6a-1a52cad5d6a1'),
(DEFAULT, 'Kubernetes Admin', '06420261-3e78-4a91-bc6a-1a52cad5d6a1'),
(DEFAULT, 'Kubernetes Dev', '06420261-3e78-4a91-bc6a-1a52cad5d6a1'),
(DEFAULT, 'Kubespray', 'c3341edb-3c1f-4e3d-bf89-8e795eb13690'),
(DEFAULT, 'LISP', '89780de3-4a4c-40c2-bcdf-b5d15a48437a'),
(DEFAULT, 'LeafletJS', '89780de3-4a4c-40c2-bcdf-b5d15a48437a'),
(DEFAULT, 'Lean', '89f5e9a5-5ce6-416c-bed9-dd736546aa7f'),
(DEFAULT, 'Lean Startup', '89f5e9a5-5ce6-416c-bed9-dd736546aa7f'),
(DEFAULT, 'Lego serious play', '89f5e9a5-5ce6-416c-bed9-dd736546aa7f'),
(DEFAULT, 'Less', '89780de3-4a4c-40c2-bcdf-b5d15a48437a'),
(DEFAULT, 'Liberating Structures', '89f5e9a5-5ce6-416c-bed9-dd736546aa7f'),
(DEFAULT, 'Linux', '06420261-3e78-4a91-bc6a-1a52cad5d6a1'),
(DEFAULT, 'Liquibase', '89780de3-4a4c-40c2-bcdf-b5d15a48437a'),
(DEFAULT, 'LitElement', '89780de3-4a4c-40c2-bcdf-b5d15a48437a'),
(DEFAULT, 'Lucene', '89780de3-4a4c-40c2-bcdf-b5d15a48437a'),
(DEFAULT, 'MLflow', '89780de3-4a4c-40c2-bcdf-b5d15a48437a'),
(DEFAULT, 'Machine Learning', '89f5e9a5-5ce6-416c-bed9-dd736546aa7f'),
(DEFAULT, 'Management 3.0', '89f5e9a5-5ce6-416c-bed9-dd736546aa7f'),
(DEFAULT, 'Maven', 'c3341edb-3c1f-4e3d-bf89-8e795eb13690'),
(DEFAULT, 'Mercurial', 'c3341edb-3c1f-4e3d-bf89-8e795eb13690'),
(DEFAULT, 'Micro frontend', '89f5e9a5-5ce6-416c-bed9-dd736546aa7f'),
(DEFAULT, 'Micronaut', '06420261-3e78-4a91-bc6a-1a52cad5d6a1'),
(DEFAULT, 'Microsoft Access', '06420261-3e78-4a91-bc6a-1a52cad5d6a1'),
(DEFAULT, 'Mob programming', '89f5e9a5-5ce6-416c-bed9-dd736546aa7f'),
(DEFAULT, 'Mockito', '89780de3-4a4c-40c2-bcdf-b5d15a48437a'),
(DEFAULT, 'MongoDB', '06420261-3e78-4a91-bc6a-1a52cad5d6a1'),
(DEFAULT, 'Motion Design', '89f5e9a5-5ce6-416c-bed9-dd736546aa7f'),
(DEFAULT, 'MySQL', '06420261-3e78-4a91-bc6a-1a52cad5d6a1'),
(DEFAULT, 'Neo4J', '06420261-3e78-4a91-bc6a-1a52cad5d6a1'),
(DEFAULT, 'NestJS', '89780de3-4a4c-40c2-bcdf-b5d15a48437a'),
(DEFAULT, 'Netlify', '06420261-3e78-4a91-bc6a-1a52cad5d6a1'),
(DEFAULT, 'NextJS', '89780de3-4a4c-40c2-bcdf-b5d15a48437a'),
(DEFAULT, 'Nexus', '06420261-3e78-4a91-bc6a-1a52cad5d6a1'),
(DEFAULT, 'NoSQL', '89f5e9a5-5ce6-416c-bed9-dd736546aa7f'),
(DEFAULT, 'Node.js', '89780de3-4a4c-40c2-bcdf-b5d15a48437a'),
(DEFAULT, 'Normalisation', '89f5e9a5-5ce6-416c-bed9-dd736546aa7f'),
(DEFAULT, 'NuxtJS', '89780de3-4a4c-40c2-bcdf-b5d15a48437a'),
(DEFAULT, 'OVHcloud', '06420261-3e78-4a91-bc6a-1a52cad5d6a1'),
(DEFAULT, 'OWASP', '89f5e9a5-5ce6-416c-bed9-dd736546aa7f'),
(DEFAULT, 'OpenStack', '06420261-3e78-4a91-bc6a-1a52cad5d6a1'),
(DEFAULT, 'Openshift', '06420261-3e78-4a91-bc6a-1a52cad5d6a1'),
(DEFAULT, 'PHP', '89780de3-4a4c-40c2-bcdf-b5d15a48437a'),
(DEFAULT, 'PWA', '89f5e9a5-5ce6-416c-bed9-dd736546aa7f'),
(DEFAULT, 'Pair programming', '89f5e9a5-5ce6-416c-bed9-dd736546aa7f'),
(DEFAULT, 'Pandas', '89780de3-4a4c-40c2-bcdf-b5d15a48437a'),
(DEFAULT, 'Play 2', '89780de3-4a4c-40c2-bcdf-b5d15a48437a'),
(DEFAULT, 'Polymer', '89780de3-4a4c-40c2-bcdf-b5d15a48437a'),
(DEFAULT, 'PostgreSQL', '06420261-3e78-4a91-bc6a-1a52cad5d6a1'),
(DEFAULT, 'Problem Solving', '89f5e9a5-5ce6-416c-bed9-dd736546aa7f'),
(DEFAULT, 'Product Management', '89f5e9a5-5ce6-416c-bed9-dd736546aa7f'),
(DEFAULT, 'Product Owner', '89f5e9a5-5ce6-416c-bed9-dd736546aa7f'),
(DEFAULT, 'Programmation fonctionnelle', '89f5e9a5-5ce6-416c-bed9-dd736546aa7f'),
(DEFAULT, 'Prometheus', '06420261-3e78-4a91-bc6a-1a52cad5d6a1'),
(DEFAULT, 'Protractor', '89780de3-4a4c-40c2-bcdf-b5d15a48437a'),
(DEFAULT, 'Psychologie positive', '89f5e9a5-5ce6-416c-bed9-dd736546aa7f'),
(DEFAULT, 'Puppet', 'c3341edb-3c1f-4e3d-bf89-8e795eb13690'),
(DEFAULT, 'Python', '89780de3-4a4c-40c2-bcdf-b5d15a48437a'),
(DEFAULT, 'Python 2', '89780de3-4a4c-40c2-bcdf-b5d15a48437a'),
(DEFAULT, 'Python 3', '89780de3-4a4c-40c2-bcdf-b5d15a48437a'),
(DEFAULT, 'Quarkus', '89780de3-4a4c-40c2-bcdf-b5d15a48437a'),
(DEFAULT, 'REST', '89f5e9a5-5ce6-416c-bed9-dd736546aa7f'),
(DEFAULT, 'RabbitMQ', '06420261-3e78-4a91-bc6a-1a52cad5d6a1'),
(DEFAULT, 'Rancher', '06420261-3e78-4a91-bc6a-1a52cad5d6a1'),
(DEFAULT, 'React Native', '89780de3-4a4c-40c2-bcdf-b5d15a48437a'),
(DEFAULT, 'ReactJS', '89780de3-4a4c-40c2-bcdf-b5d15a48437a'),
(DEFAULT, 'Recrutement', '89f5e9a5-5ce6-416c-bed9-dd736546aa7f'),
(DEFAULT, 'Redis', '06420261-3e78-4a91-bc6a-1a52cad5d6a1'),
(DEFAULT, 'Refactoring', '89f5e9a5-5ce6-416c-bed9-dd736546aa7f'),
(DEFAULT, 'Rust', '89780de3-4a4c-40c2-bcdf-b5d15a48437a'),
(DEFAULT, 'RxJS', '89780de3-4a4c-40c2-bcdf-b5d15a48437a'),
(DEFAULT, 'RxJava', '89780de3-4a4c-40c2-bcdf-b5d15a48437a'),
(DEFAULT, 'SAFe', '89f5e9a5-5ce6-416c-bed9-dd736546aa7f'),
(DEFAULT, 'SBT', 'c3341edb-3c1f-4e3d-bf89-8e795eb13690'),
(DEFAULT, 'SEO', '89f5e9a5-5ce6-416c-bed9-dd736546aa7f'),
(DEFAULT, 'SQL', '89780de3-4a4c-40c2-bcdf-b5d15a48437a'),
(DEFAULT, 'SVG', '89780de3-4a4c-40c2-bcdf-b5d15a48437a'),
(DEFAULT, 'SVN', 'c3341edb-3c1f-4e3d-bf89-8e795eb13690'),
(DEFAULT, 'Salt(stack)', 'c3341edb-3c1f-4e3d-bf89-8e795eb13690'),
(DEFAULT, 'Sass', '89780de3-4a4c-40c2-bcdf-b5d15a48437a'),
(DEFAULT, 'Scala', '89780de3-4a4c-40c2-bcdf-b5d15a48437a'),
(DEFAULT, 'Scaled Agile', '89f5e9a5-5ce6-416c-bed9-dd736546aa7f'),
(DEFAULT, 'Scikit-Learn', '89f5e9a5-5ce6-416c-bed9-dd736546aa7f'),
(DEFAULT, 'Scrum', '89f5e9a5-5ce6-416c-bed9-dd736546aa7f'),
(DEFAULT, 'Scrum Master', '89f5e9a5-5ce6-416c-bed9-dd736546aa7f'),
(DEFAULT, 'Scrumban', '89f5e9a5-5ce6-416c-bed9-dd736546aa7f'),
(DEFAULT, 'Serious game', '89f5e9a5-5ce6-416c-bed9-dd736546aa7f'),
(DEFAULT, 'Serverless', '06420261-3e78-4a91-bc6a-1a52cad5d6a1'),
(DEFAULT, 'Service Mesh', '06420261-3e78-4a91-bc6a-1a52cad5d6a1'),
(DEFAULT, 'Site Reliability Engineering', '89f5e9a5-5ce6-416c-bed9-dd736546aa7f'),
(DEFAULT, 'Snowpack', 'c3341edb-3c1f-4e3d-bf89-8e795eb13690'),
(DEFAULT, 'Solr', '06420261-3e78-4a91-bc6a-1a52cad5d6a1'),
(DEFAULT, 'Solution Focus', '89f5e9a5-5ce6-416c-bed9-dd736546aa7f'),
(DEFAULT, 'Sonar', '06420261-3e78-4a91-bc6a-1a52cad5d6a1'),
(DEFAULT, 'Spark', '06420261-3e78-4a91-bc6a-1a52cad5d6a1'),
(DEFAULT, 'Spring', '89780de3-4a4c-40c2-bcdf-b5d15a48437a'),
(DEFAULT, 'Spring Batch', '89780de3-4a4c-40c2-bcdf-b5d15a48437a'),
(DEFAULT, 'Spring Boot', '89780de3-4a4c-40c2-bcdf-b5d15a48437a'),
(DEFAULT, 'Spring Cloud', '89780de3-4a4c-40c2-bcdf-b5d15a48437a'),
(DEFAULT, 'Spring Data', '89780de3-4a4c-40c2-bcdf-b5d15a48437a'),
(DEFAULT, 'Spring Reactor', '89780de3-4a4c-40c2-bcdf-b5d15a48437a'),
(DEFAULT, 'Spring Security', '89780de3-4a4c-40c2-bcdf-b5d15a48437a'),
(DEFAULT, 'StencilJS', '89780de3-4a4c-40c2-bcdf-b5d15a48437a'),
(DEFAULT, 'Storybook', '89780de3-4a4c-40c2-bcdf-b5d15a48437a'),
(DEFAULT, 'Stylus', '89780de3-4a4c-40c2-bcdf-b5d15a48437a'),
(DEFAULT, 'SvelteJS', '89780de3-4a4c-40c2-bcdf-b5d15a48437a'),
(DEFAULT, 'Swagger', '89780de3-4a4c-40c2-bcdf-b5d15a48437a'),
(DEFAULT, 'Swift', '89780de3-4a4c-40c2-bcdf-b5d15a48437a'),
(DEFAULT, 'Symfony', '89780de3-4a4c-40c2-bcdf-b5d15a48437a'),
(DEFAULT, 'Sécurité', '89f5e9a5-5ce6-416c-bed9-dd736546aa7f'),
(DEFAULT, 'TDD', '89f5e9a5-5ce6-416c-bed9-dd736546aa7f'),
(DEFAULT, 'Tech Lead', '89f5e9a5-5ce6-416c-bed9-dd736546aa7f'),
(DEFAULT, 'TensorFlow', '89780de3-4a4c-40c2-bcdf-b5d15a48437a'),
(DEFAULT, 'Terraform', 'c3341edb-3c1f-4e3d-bf89-8e795eb13690'),
(DEFAULT, 'Tests', '89f5e9a5-5ce6-416c-bed9-dd736546aa7f'),
(DEFAULT, 'Thanos', '06420261-3e78-4a91-bc6a-1a52cad5d6a1'),
(DEFAULT, 'Traefik', '06420261-3e78-4a91-bc6a-1a52cad5d6a1'),
(DEFAULT, 'TypeScript', '89780de3-4a4c-40c2-bcdf-b5d15a48437a'),
(DEFAULT, 'UI', '89f5e9a5-5ce6-416c-bed9-dd736546aa7f'),
(DEFAULT, 'UML', '89780de3-4a4c-40c2-bcdf-b5d15a48437a'),
(DEFAULT, 'UX', '89f5e9a5-5ce6-416c-bed9-dd736546aa7f'),
(DEFAULT, 'VBA', '89780de3-4a4c-40c2-bcdf-b5d15a48437a'),
(DEFAULT, 'VHDL', '89780de3-4a4c-40c2-bcdf-b5d15a48437a'),
(DEFAULT, 'VPS', '06420261-3e78-4a91-bc6a-1a52cad5d6a1'),
(DEFAULT, 'Vagrant', 'c3341edb-3c1f-4e3d-bf89-8e795eb13690'),
(DEFAULT, 'Vault', '06420261-3e78-4a91-bc6a-1a52cad5d6a1'),
(DEFAULT, 'Velero', 'c3341edb-3c1f-4e3d-bf89-8e795eb13690'),
(DEFAULT, 'Vert.x', '06420261-3e78-4a91-bc6a-1a52cad5d6a1'),
(DEFAULT, 'Vite', 'c3341edb-3c1f-4e3d-bf89-8e795eb13690'),
(DEFAULT, 'VueJS', '89780de3-4a4c-40c2-bcdf-b5d15a48437a'),
(DEFAULT, 'VueJS 2', '89780de3-4a4c-40c2-bcdf-b5d15a48437a'),
(DEFAULT, 'VueJS 3', '89780de3-4a4c-40c2-bcdf-b5d15a48437a'),
(DEFAULT, 'Web Components', '89f5e9a5-5ce6-416c-bed9-dd736546aa7f'),
(DEFAULT, 'WebAssembly', '89780de3-4a4c-40c2-bcdf-b5d15a48437a'),
(DEFAULT, 'Webpack', 'c3341edb-3c1f-4e3d-bf89-8e795eb13690'),
(DEFAULT, 'WordPress', '06420261-3e78-4a91-bc6a-1a52cad5d6a1'),
(DEFAULT, 'jQuery', '89780de3-4a4c-40c2-bcdf-b5d15a48437a'),
(DEFAULT, 'k3s', 'c3341edb-3c1f-4e3d-bf89-8e795eb13690'),
(DEFAULT, 'pyTorch', '89780de3-4a4c-40c2-bcdf-b5d15a48437a'),
(DEFAULT, 'webrtc', '89f5e9a5-5ce6-416c-bed9-dd736546aa7f');
