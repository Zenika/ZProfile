CREATE TABLE "public"."UserSkillDesire"("userEmail" text NOT NULL, "skillId" uuid NOT NULL, "skillLevel" integer NOT NULL, "desireLevel" integer NOT NULL, "created_at" date NOT NULL DEFAULT now(), PRIMARY KEY ("userEmail","skillId") , UNIQUE ("userEmail", "skillId", "created_at"));