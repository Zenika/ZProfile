CREATE OR REPLACE VIEW "public"."UsersCurrentSkillsAndDesires" AS 
 SELECT "Skill".id AS "skillId",
    "Skill"."categoryId",
    "UserSkill"."userEmail",
    "Skill".name,
    "UserSkill".level,
    "TechnicalAppetite".level AS desire
   FROM (("Skill"
     JOIN "UserSkill" ON (("Skill".id = "UserSkill"."skillId")))
     JOIN "TechnicalAppetite" ON (("Skill".id = "TechnicalAppetite"."skillId")))
  WHERE (("UserSkill"."userEmail", "Skill".name, "UserSkill".created_at, "TechnicalAppetite".created_at) IN ( SELECT "UserSkill_1"."userEmail",
            "Skill_1".name,
            max("UserSkill_1".created_at) AS max,
            max("TechnicalAppetite_1".created_at) AS max
           FROM (("Skill" "Skill_1"
             JOIN "UserSkill" "UserSkill_1" ON (("Skill_1".id = "UserSkill_1"."skillId")))
             JOIN "TechnicalAppetite" "TechnicalAppetite_1" ON (("Skill_1".id = "TechnicalAppetite_1"."skillId")))
          GROUP BY "UserSkill_1"."userEmail", "Skill_1".name))
  ORDER BY ("UserSkill".level + "TechnicalAppetite".level) DESC;
