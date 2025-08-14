CREATE TYPE "public"."user_role" AS ENUM('student', 'manager');--> statement-breakpoint
ALTER TABLE "users" ADD COLUMN "role" "user_role" DEFAULT 'student' NOT NULL;