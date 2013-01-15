--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


--
-- Name: hstore; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS hstore WITH SCHEMA public;


--
-- Name: EXTENSION hstore; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION hstore IS 'data type for storing sets of (key, value) pairs';


SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: acknowledgements; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE acknowledgements (
    id integer NOT NULL,
    community_profile_id integer,
    announcement_id integer,
    has_been_viewed boolean DEFAULT false,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: acknowledgements_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE acknowledgements_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: acknowledgements_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE acknowledgements_id_seq OWNED BY acknowledgements.id;


--
-- Name: active_admin_comments; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE active_admin_comments (
    id integer NOT NULL,
    resource_id integer NOT NULL,
    resource_type character varying(255) NOT NULL,
    author_id integer,
    author_type character varying(255),
    body text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    namespace character varying(255)
);


--
-- Name: active_admin_comments_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE active_admin_comments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: active_admin_comments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE active_admin_comments_id_seq OWNED BY active_admin_comments.id;


--
-- Name: activities; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE activities (
    id integer NOT NULL,
    user_profile_id integer,
    community_id integer,
    target_type character varying(255),
    target_id integer,
    action character varying(255),
    deleted_at timestamp without time zone,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: activities_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE activities_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: activities_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE activities_id_seq OWNED BY activities.id;


--
-- Name: admin_users; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE admin_users (
    id integer NOT NULL,
    email character varying(255) DEFAULT ''::character varying NOT NULL,
    encrypted_password character varying(255) DEFAULT ''::character varying NOT NULL,
    reset_password_token character varying(255),
    reset_password_sent_at timestamp without time zone,
    sign_in_count integer DEFAULT 0,
    current_sign_in_at timestamp without time zone,
    last_sign_in_at timestamp without time zone,
    current_sign_in_ip character varying(255),
    last_sign_in_ip character varying(255),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    role character varying(255),
    failed_attempts integer DEFAULT 0,
    unlock_token character varying(255),
    locked_at timestamp without time zone,
    display_name character varying(255),
    avatar character varying(255),
    auth_secret character varying(255)
);


--
-- Name: admin_users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE admin_users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: admin_users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE admin_users_id_seq OWNED BY admin_users.id;


--
-- Name: announcements; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE announcements (
    id integer NOT NULL,
    name character varying(255),
    body text,
    character_proxy_id integer,
    user_profile_id integer,
    community_id integer,
    supported_game_id integer,
    is_locked boolean DEFAULT false,
    deleted_at timestamp without time zone,
    has_been_edited boolean DEFAULT false,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    community_game_id integer,
    character_id integer
);


--
-- Name: announcements_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE announcements_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: announcements_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE announcements_id_seq OWNED BY announcements.id;


--
-- Name: answers; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE answers (
    id integer NOT NULL,
    body text,
    submission_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    deleted_at timestamp without time zone,
    question_body character varying(255)
);


--
-- Name: answers_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE answers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: answers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE answers_id_seq OWNED BY answers.id;


--
-- Name: artwork_uploads; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE artwork_uploads (
    id integer NOT NULL,
    owner_name character varying(255),
    email character varying(255),
    street character varying(255),
    city character varying(255),
    zipcode character varying(255),
    state character varying(255),
    country character varying(255),
    attribution_name character varying(255),
    attribution_url character varying(255),
    artwork_image character varying(255),
    artwork_description character varying(255),
    certify_owner_of_artwork boolean,
    document_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: artwork_uploads_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE artwork_uploads_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: artwork_uploads_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE artwork_uploads_id_seq OWNED BY artwork_uploads.id;


--
-- Name: character_proxies; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE character_proxies (
    id integer NOT NULL,
    user_profile_id integer,
    character_id integer,
    character_type character varying(255),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    is_removed boolean DEFAULT false
);


--
-- Name: character_proxies_community_applications; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE character_proxies_community_applications (
    character_proxy_id integer,
    community_application_id integer
);


--
-- Name: character_proxies_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE character_proxies_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: character_proxies_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE character_proxies_id_seq OWNED BY character_proxies.id;


--
-- Name: characters; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE characters (
    id integer NOT NULL,
    name character varying(255),
    avatar character varying(255),
    about text,
    played_game_id integer,
    info hstore,
    type character varying(255),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    is_removed boolean
);


--
-- Name: characters_community_applications; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE characters_community_applications (
    character_id integer NOT NULL,
    community_application_id integer NOT NULL
);


--
-- Name: characters_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE characters_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: characters_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE characters_id_seq OWNED BY characters.id;


--
-- Name: comments; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE comments (
    id integer NOT NULL,
    body text,
    user_profile_id integer,
    character_proxy_id integer,
    community_id integer,
    commentable_id integer,
    commentable_type character varying(255),
    is_removed boolean DEFAULT false,
    has_been_edited boolean DEFAULT false,
    is_locked boolean DEFAULT false,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    original_commentable_id integer,
    original_commentable_type character varying(255),
    deleted_at timestamp without time zone,
    character_id integer
);


--
-- Name: comments_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE comments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: comments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE comments_id_seq OWNED BY comments.id;


--
-- Name: communities; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE communities (
    id integer NOT NULL,
    name character varying(255),
    slogan character varying(255),
    is_accepting_members boolean DEFAULT true,
    email_notice_on_application boolean DEFAULT true,
    subdomain character varying(255),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    admin_profile_id integer,
    member_role_id integer,
    is_protected_roster boolean DEFAULT false,
    community_application_form_id integer,
    community_announcement_space_id integer,
    is_public_roster boolean DEFAULT true,
    deleted_at timestamp without time zone,
    background_image character varying(255),
    background_color character varying(255),
    theme_id integer,
    title_color character varying(255),
    home_page_id integer,
    pending_removal boolean DEFAULT false,
    action_items text,
    community_plan_id integer,
    community_profiles_count integer DEFAULT 0
);


--
-- Name: communities_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE communities_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: communities_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE communities_id_seq OWNED BY communities.id;


--
-- Name: community_applications; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE community_applications (
    id integer NOT NULL,
    community_id integer,
    user_profile_id integer,
    submission_id integer,
    status character varying(255),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    status_changer_id integer,
    deleted_at timestamp without time zone
);


--
-- Name: community_applications_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE community_applications_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: community_applications_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE community_applications_id_seq OWNED BY community_applications.id;


--
-- Name: community_games; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE community_games (
    id integer NOT NULL,
    community_id integer,
    game_id integer,
    game_announcement_space_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    deleted_at timestamp without time zone,
    info hstore
);


--
-- Name: community_games_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE community_games_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: community_games_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE community_games_id_seq OWNED BY community_games.id;


--
-- Name: community_invites; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE community_invites (
    id integer NOT NULL,
    applicant_id integer,
    sponsor_id integer,
    community_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    email character varying(255)
);


--
-- Name: community_invites_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE community_invites_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: community_invites_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE community_invites_id_seq OWNED BY community_invites.id;


--
-- Name: community_plan_upgrades; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE community_plan_upgrades (
    id integer NOT NULL,
    community_plan_id integer,
    community_upgrade_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: community_plan_upgrades_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE community_plan_upgrades_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: community_plan_upgrades_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE community_plan_upgrades_id_seq OWNED BY community_plan_upgrades.id;


--
-- Name: community_plans; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE community_plans (
    id integer NOT NULL,
    title character varying(255),
    description text,
    price_per_month_in_cents integer,
    is_available boolean DEFAULT true,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    max_number_of_users integer DEFAULT 0
);


--
-- Name: community_plans_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE community_plans_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: community_plans_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE community_plans_id_seq OWNED BY community_plans.id;


--
-- Name: community_profiles; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE community_profiles (
    id integer NOT NULL,
    community_id integer,
    user_profile_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    deleted_at timestamp without time zone,
    community_application_id integer
);


--
-- Name: community_profiles_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE community_profiles_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: community_profiles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE community_profiles_id_seq OWNED BY community_profiles.id;


--
-- Name: community_profiles_roles; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE community_profiles_roles (
    community_profile_id integer,
    role_id integer
);


--
-- Name: community_upgrades; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE community_upgrades (
    id integer NOT NULL,
    title character varying(255),
    description text,
    price_per_month_in_cents integer,
    max_number_of_upgrades integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    type character varying(255),
    upgrade_options text
);


--
-- Name: community_upgrades_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE community_upgrades_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: community_upgrades_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE community_upgrades_id_seq OWNED BY community_upgrades.id;


--
-- Name: custom_forms; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE custom_forms (
    id integer NOT NULL,
    name character varying(255),
    instructions text,
    thankyou character varying(255),
    is_published boolean DEFAULT false,
    community_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    deleted_at timestamp without time zone
);


--
-- Name: custom_forms_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE custom_forms_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: custom_forms_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE custom_forms_id_seq OWNED BY custom_forms.id;


--
-- Name: delayed_jobs; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE delayed_jobs (
    id integer NOT NULL,
    priority integer DEFAULT 0,
    attempts integer DEFAULT 0,
    handler text,
    last_error text,
    run_at timestamp without time zone,
    locked_at timestamp without time zone,
    failed_at timestamp without time zone,
    locked_by character varying(255),
    queue character varying(255),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: delayed_jobs_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE delayed_jobs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: delayed_jobs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE delayed_jobs_id_seq OWNED BY delayed_jobs.id;


--
-- Name: discussion_spaces; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE discussion_spaces (
    id integer NOT NULL,
    name character varying(255),
    supported_game_id integer,
    community_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    is_announcement_space boolean DEFAULT false,
    deleted_at timestamp without time zone,
    community_game_id integer
);


--
-- Name: discussion_spaces_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE discussion_spaces_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: discussion_spaces_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE discussion_spaces_id_seq OWNED BY discussion_spaces.id;


--
-- Name: discussions; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE discussions (
    id integer NOT NULL,
    name character varying(255),
    body text,
    discussion_space_id integer,
    character_proxy_id integer,
    user_profile_id integer,
    is_locked boolean DEFAULT false,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    deleted_at timestamp without time zone,
    has_been_edited boolean DEFAULT false,
    character_id integer
);


--
-- Name: discussions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE discussions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: discussions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE discussions_id_seq OWNED BY discussions.id;


--
-- Name: document_acceptances; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE document_acceptances (
    id integer NOT NULL,
    user_id integer,
    document_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    is_current boolean DEFAULT true
);


--
-- Name: document_acceptances_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE document_acceptances_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: document_acceptances_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE document_acceptances_id_seq OWNED BY document_acceptances.id;


--
-- Name: documents; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE documents (
    id integer NOT NULL,
    type character varying(255),
    body text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    version integer,
    is_published boolean DEFAULT false
);


--
-- Name: documents_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE documents_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: documents_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE documents_id_seq OWNED BY documents.id;


--
-- Name: events; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE events (
    id integer NOT NULL,
    name character varying(255),
    body text,
    start_time timestamp without time zone,
    end_time timestamp without time zone,
    creator_id integer,
    supported_game_id integer,
    community_id integer,
    is_public boolean DEFAULT false,
    location character varying(255),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    community_game_id integer
);


--
-- Name: events_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE events_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: events_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE events_id_seq OWNED BY events.id;


--
-- Name: folders; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE folders (
    id integer NOT NULL,
    name character varying(255),
    user_profile_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: folders_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE folders_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: folders_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE folders_id_seq OWNED BY folders.id;


--
-- Name: games; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE games (
    id integer NOT NULL,
    name character varying(255),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    type character varying(255),
    info hstore,
    aliases character varying(255)
);


--
-- Name: games_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE games_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: games_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE games_id_seq OWNED BY games.id;


--
-- Name: invites; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE invites (
    id integer NOT NULL,
    event_id integer,
    user_profile_id integer,
    character_proxy_id integer,
    status character varying(255),
    is_viewed boolean DEFAULT false,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    expiration timestamp without time zone,
    character_id integer
);


--
-- Name: invites_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE invites_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: invites_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE invites_id_seq OWNED BY invites.id;


--
-- Name: invoice_items; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE invoice_items (
    id integer NOT NULL,
    quantity integer,
    start_date timestamp without time zone,
    end_date timestamp without time zone,
    item_type character varying(255),
    item_id integer,
    community_id integer,
    is_recurring boolean DEFAULT true,
    is_prorated boolean DEFAULT false,
    invoice_id integer,
    deleted_at timestamp without time zone,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: invoice_items_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE invoice_items_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: invoice_items_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE invoice_items_id_seq OWNED BY invoice_items.id;


--
-- Name: invoices; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE invoices (
    id integer NOT NULL,
    user_id integer,
    stripe_charge_id character varying(255),
    period_start_date timestamp without time zone,
    period_end_date timestamp without time zone,
    paid_date timestamp without time zone,
    discount_percent_off integer DEFAULT 0,
    discount_discription character varying(255),
    deleted_at timestamp without time zone,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    is_closed boolean DEFAULT false,
    processing_payment boolean DEFAULT false,
    charged_total_price_in_cents integer,
    first_failed_attempt_date timestamp without time zone,
    lock_version integer DEFAULT 0 NOT NULL,
    charged_state_tax_rate double precision DEFAULT 0.0,
    charged_local_tax_rate double precision DEFAULT 0.0,
    local_tax_code character varying(255),
    disputed_date timestamp without time zone,
    refunded_date timestamp without time zone,
    refunded_price_in_cents integer,
    tax_error_occurred boolean DEFAULT false
);


--
-- Name: invoices_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE invoices_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: invoices_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE invoices_id_seq OWNED BY invoices.id;


--
-- Name: message_associations; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE message_associations (
    id integer NOT NULL,
    message_id integer,
    recipient_id integer,
    folder_id integer,
    is_removed boolean DEFAULT false,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    has_been_read boolean DEFAULT false
);


--
-- Name: message_associations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE message_associations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: message_associations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE message_associations_id_seq OWNED BY message_associations.id;


--
-- Name: messages; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE messages (
    id integer NOT NULL,
    subject character varying(255),
    body text,
    author_id integer,
    number_recipients integer,
    is_system_sent boolean DEFAULT false,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    dont_send_email boolean DEFAULT false
);


--
-- Name: messages_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE messages_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: messages_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE messages_id_seq OWNED BY messages.id;


--
-- Name: minecraft_characters; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE minecraft_characters (
    id integer NOT NULL,
    name character varying(255),
    avatar character varying(255),
    about text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: minecraft_characters_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE minecraft_characters_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: minecraft_characters_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE minecraft_characters_id_seq OWNED BY minecraft_characters.id;


--
-- Name: minecrafts; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE minecrafts (
    id integer NOT NULL,
    server_type character varying(255),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: minecrafts_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE minecrafts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: minecrafts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE minecrafts_id_seq OWNED BY minecrafts.id;


--
-- Name: page_spaces; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE page_spaces (
    id integer NOT NULL,
    name character varying(255),
    supported_game_id integer,
    community_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    deleted_at timestamp without time zone,
    community_game_id integer
);


--
-- Name: page_spaces_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE page_spaces_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: page_spaces_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE page_spaces_id_seq OWNED BY page_spaces.id;


--
-- Name: pages; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE pages (
    id integer NOT NULL,
    name character varying(255),
    markup text,
    page_space_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    deleted_at timestamp without time zone
);


--
-- Name: pages_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE pages_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: pages_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE pages_id_seq OWNED BY pages.id;


--
-- Name: permission_defaults; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE permission_defaults (
    id integer NOT NULL,
    role_id integer,
    object_class character varying(255),
    permission_level character varying(255),
    can_read boolean DEFAULT false,
    can_update boolean DEFAULT false,
    can_create boolean DEFAULT false,
    can_destroy boolean DEFAULT false,
    can_lock boolean DEFAULT false,
    can_accept boolean DEFAULT false,
    nested_permission_level character varying(255),
    can_read_nested boolean DEFAULT false,
    can_update_nested boolean DEFAULT false,
    can_create_nested boolean DEFAULT false,
    can_destroy_nested boolean DEFAULT false,
    can_lock_nested boolean DEFAULT false,
    can_accept_nested boolean DEFAULT false,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    deleted_at timestamp without time zone
);


--
-- Name: permission_defaults_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE permission_defaults_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: permission_defaults_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE permission_defaults_id_seq OWNED BY permission_defaults.id;


--
-- Name: permissions; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE permissions (
    id integer NOT NULL,
    role_id integer,
    permission_level character varying(255),
    subject_class character varying(255),
    id_of_subject integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    can_lock boolean DEFAULT false,
    can_accept boolean DEFAULT false,
    parent_association_for_subject character varying(255),
    id_of_parent integer,
    can_read boolean DEFAULT false,
    can_create boolean DEFAULT false,
    can_update boolean DEFAULT false,
    can_destroy boolean DEFAULT false,
    deleted_at timestamp without time zone
);


--
-- Name: permissions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE permissions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: permissions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE permissions_id_seq OWNED BY permissions.id;


--
-- Name: played_games; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE played_games (
    id integer NOT NULL,
    game_id integer,
    user_profile_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: played_games_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE played_games_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: played_games_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE played_games_id_seq OWNED BY played_games.id;


--
-- Name: predefined_answers; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE predefined_answers (
    id integer NOT NULL,
    body text,
    question_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    deleted_at timestamp without time zone,
    "position" integer DEFAULT 0
);


--
-- Name: predefined_answers_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE predefined_answers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: predefined_answers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE predefined_answers_id_seq OWNED BY predefined_answers.id;


--
-- Name: questions; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE questions (
    id integer NOT NULL,
    body text,
    custom_form_id integer,
    style character varying(255),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    explanation character varying(255),
    is_required boolean DEFAULT false,
    deleted_at timestamp without time zone,
    "position" integer DEFAULT 0
);


--
-- Name: questions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE questions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: questions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE questions_id_seq OWNED BY questions.id;


--
-- Name: roles; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE roles (
    id integer NOT NULL,
    community_id integer,
    name character varying(255),
    is_system_generated boolean DEFAULT false,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    deleted_at timestamp without time zone
);


--
-- Name: roles_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE roles_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: roles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE roles_id_seq OWNED BY roles.id;


--
-- Name: roster_assignments; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE roster_assignments (
    id integer NOT NULL,
    community_profile_id integer,
    character_proxy_id integer,
    is_pending boolean DEFAULT true,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    deleted_at timestamp without time zone,
    supported_game_id integer,
    community_game_id integer,
    character_id integer
);


--
-- Name: roster_assignments_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE roster_assignments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: roster_assignments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE roster_assignments_id_seq OWNED BY roster_assignments.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE schema_migrations (
    version character varying(255) NOT NULL
);


--
-- Name: site_configurations; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE site_configurations (
    id integer NOT NULL,
    is_maintenance boolean DEFAULT false,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: site_configurations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE site_configurations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: site_configurations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE site_configurations_id_seq OWNED BY site_configurations.id;


--
-- Name: submissions; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE submissions (
    id integer NOT NULL,
    custom_form_id integer,
    user_profile_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    deleted_at timestamp without time zone
);


--
-- Name: submissions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE submissions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: submissions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE submissions_id_seq OWNED BY submissions.id;


--
-- Name: support_comments; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE support_comments (
    id integer NOT NULL,
    support_ticket_id integer,
    user_profile_id integer,
    admin_user_id integer,
    body text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: support_comments_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE support_comments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: support_comments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE support_comments_id_seq OWNED BY support_comments.id;


--
-- Name: support_tickets; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE support_tickets (
    id integer NOT NULL,
    user_profile_id integer,
    admin_user_id integer,
    status character varying(255),
    body text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: support_tickets_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE support_tickets_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: support_tickets_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE support_tickets_id_seq OWNED BY support_tickets.id;


--
-- Name: supported_games; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE supported_games (
    id integer NOT NULL,
    community_id integer,
    game_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    game_announcement_space_id integer,
    name character varying(255),
    game_type character varying(255),
    deleted_at timestamp without time zone
);


--
-- Name: supported_games_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE supported_games_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: supported_games_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE supported_games_id_seq OWNED BY supported_games.id;


--
-- Name: swtor_characters; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE swtor_characters (
    id integer NOT NULL,
    name character varying(255),
    swtor_id integer,
    avatar character varying(255),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    char_class character varying(255),
    advanced_class character varying(255),
    species character varying(255),
    level character varying(255),
    about character varying(255),
    gender character varying(255)
);


--
-- Name: swtor_characters_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE swtor_characters_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: swtor_characters_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE swtor_characters_id_seq OWNED BY swtor_characters.id;


--
-- Name: swtors; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE swtors (
    id integer NOT NULL,
    faction character varying(255),
    server_name character varying(255),
    server_type character varying(255),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: swtors_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE swtors_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: swtors_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE swtors_id_seq OWNED BY swtors.id;


--
-- Name: themes; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE themes (
    id integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    name character varying(255),
    css character varying(255),
    background_author character varying(255),
    background_author_url character varying(255),
    thumbnail character varying(255)
);


--
-- Name: themes_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE themes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: themes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE themes_id_seq OWNED BY themes.id;


--
-- Name: user_profiles; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE user_profiles (
    id integer NOT NULL,
    avatar character varying(255),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    description text,
    display_name character varying(255),
    publicly_viewable boolean DEFAULT true,
    title character varying(255),
    location character varying(255),
    full_name character varying(255),
    gamer_tag character varying(255),
    slug character varying(255)
);


--
-- Name: user_profiles_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE user_profiles_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: user_profiles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE user_profiles_id_seq OWNED BY user_profiles.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE users (
    id integer NOT NULL,
    email character varying(255) DEFAULT ''::character varying NOT NULL,
    encrypted_password character varying(255) DEFAULT ''::character varying NOT NULL,
    reset_password_token character varying(255),
    reset_password_sent_at timestamp without time zone,
    remember_created_at timestamp without time zone,
    confirmation_token character varying(255),
    confirmed_at timestamp without time zone,
    confirmation_sent_at timestamp without time zone,
    unconfirmed_email character varying(255),
    failed_attempts integer DEFAULT 0,
    unlock_token character varying(255),
    locked_at timestamp without time zone,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    accepted_current_terms_of_service boolean DEFAULT false,
    accepted_current_privacy_policy boolean DEFAULT false,
    force_logout boolean DEFAULT false,
    date_of_birth date,
    user_disabled_at timestamp without time zone,
    admin_disabled_at timestamp without time zone,
    user_profile_id integer,
    time_zone integer DEFAULT (-8),
    is_email_on_message boolean DEFAULT true,
    is_email_on_announcement boolean DEFAULT true,
    stripe_customer_token character varying(255),
    is_in_good_account_standing boolean DEFAULT true
);


--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE users_id_seq OWNED BY users.id;


--
-- Name: view_logs; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE view_logs (
    id integer NOT NULL,
    user_profile_id integer,
    view_loggable_id integer,
    view_loggable_type character varying(255),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    deleted_at timestamp without time zone
);


--
-- Name: view_logs_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE view_logs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: view_logs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE view_logs_id_seq OWNED BY view_logs.id;


--
-- Name: wow_characters; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE wow_characters (
    id integer NOT NULL,
    name character varying(255),
    race character varying(255),
    level integer,
    wow_id integer,
    avatar character varying(255),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    char_class character varying(255),
    about text,
    gender character varying(255)
);


--
-- Name: wow_characters_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE wow_characters_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: wow_characters_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE wow_characters_id_seq OWNED BY wow_characters.id;


--
-- Name: wows; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE wows (
    id integer NOT NULL,
    faction character varying(255),
    server_name character varying(255),
    server_type character varying(255),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: wows_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE wows_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: wows_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE wows_id_seq OWNED BY wows.id;


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY acknowledgements ALTER COLUMN id SET DEFAULT nextval('acknowledgements_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY active_admin_comments ALTER COLUMN id SET DEFAULT nextval('active_admin_comments_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY activities ALTER COLUMN id SET DEFAULT nextval('activities_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY admin_users ALTER COLUMN id SET DEFAULT nextval('admin_users_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY announcements ALTER COLUMN id SET DEFAULT nextval('announcements_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY answers ALTER COLUMN id SET DEFAULT nextval('answers_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY artwork_uploads ALTER COLUMN id SET DEFAULT nextval('artwork_uploads_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY character_proxies ALTER COLUMN id SET DEFAULT nextval('character_proxies_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY characters ALTER COLUMN id SET DEFAULT nextval('characters_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY comments ALTER COLUMN id SET DEFAULT nextval('comments_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY communities ALTER COLUMN id SET DEFAULT nextval('communities_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY community_applications ALTER COLUMN id SET DEFAULT nextval('community_applications_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY community_games ALTER COLUMN id SET DEFAULT nextval('community_games_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY community_invites ALTER COLUMN id SET DEFAULT nextval('community_invites_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY community_plan_upgrades ALTER COLUMN id SET DEFAULT nextval('community_plan_upgrades_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY community_plans ALTER COLUMN id SET DEFAULT nextval('community_plans_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY community_profiles ALTER COLUMN id SET DEFAULT nextval('community_profiles_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY community_upgrades ALTER COLUMN id SET DEFAULT nextval('community_upgrades_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY custom_forms ALTER COLUMN id SET DEFAULT nextval('custom_forms_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY delayed_jobs ALTER COLUMN id SET DEFAULT nextval('delayed_jobs_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY discussion_spaces ALTER COLUMN id SET DEFAULT nextval('discussion_spaces_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY discussions ALTER COLUMN id SET DEFAULT nextval('discussions_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY document_acceptances ALTER COLUMN id SET DEFAULT nextval('document_acceptances_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY documents ALTER COLUMN id SET DEFAULT nextval('documents_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY events ALTER COLUMN id SET DEFAULT nextval('events_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY folders ALTER COLUMN id SET DEFAULT nextval('folders_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY games ALTER COLUMN id SET DEFAULT nextval('games_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY invites ALTER COLUMN id SET DEFAULT nextval('invites_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY invoice_items ALTER COLUMN id SET DEFAULT nextval('invoice_items_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY invoices ALTER COLUMN id SET DEFAULT nextval('invoices_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY message_associations ALTER COLUMN id SET DEFAULT nextval('message_associations_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY messages ALTER COLUMN id SET DEFAULT nextval('messages_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY minecraft_characters ALTER COLUMN id SET DEFAULT nextval('minecraft_characters_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY minecrafts ALTER COLUMN id SET DEFAULT nextval('minecrafts_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY page_spaces ALTER COLUMN id SET DEFAULT nextval('page_spaces_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY pages ALTER COLUMN id SET DEFAULT nextval('pages_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY permission_defaults ALTER COLUMN id SET DEFAULT nextval('permission_defaults_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY permissions ALTER COLUMN id SET DEFAULT nextval('permissions_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY played_games ALTER COLUMN id SET DEFAULT nextval('played_games_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY predefined_answers ALTER COLUMN id SET DEFAULT nextval('predefined_answers_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY questions ALTER COLUMN id SET DEFAULT nextval('questions_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY roles ALTER COLUMN id SET DEFAULT nextval('roles_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY roster_assignments ALTER COLUMN id SET DEFAULT nextval('roster_assignments_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY site_configurations ALTER COLUMN id SET DEFAULT nextval('site_configurations_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY submissions ALTER COLUMN id SET DEFAULT nextval('submissions_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY support_comments ALTER COLUMN id SET DEFAULT nextval('support_comments_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY support_tickets ALTER COLUMN id SET DEFAULT nextval('support_tickets_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY supported_games ALTER COLUMN id SET DEFAULT nextval('supported_games_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY swtor_characters ALTER COLUMN id SET DEFAULT nextval('swtor_characters_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY swtors ALTER COLUMN id SET DEFAULT nextval('swtors_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY themes ALTER COLUMN id SET DEFAULT nextval('themes_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY user_profiles ALTER COLUMN id SET DEFAULT nextval('user_profiles_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY users ALTER COLUMN id SET DEFAULT nextval('users_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY view_logs ALTER COLUMN id SET DEFAULT nextval('view_logs_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY wow_characters ALTER COLUMN id SET DEFAULT nextval('wow_characters_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY wows ALTER COLUMN id SET DEFAULT nextval('wows_id_seq'::regclass);


--
-- Name: acknowledgements_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY acknowledgements
    ADD CONSTRAINT acknowledgements_pkey PRIMARY KEY (id);


--
-- Name: activities_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY activities
    ADD CONSTRAINT activities_pkey PRIMARY KEY (id);


--
-- Name: admin_notes_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY active_admin_comments
    ADD CONSTRAINT admin_notes_pkey PRIMARY KEY (id);


--
-- Name: admin_users_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY admin_users
    ADD CONSTRAINT admin_users_pkey PRIMARY KEY (id);


--
-- Name: announcements_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY announcements
    ADD CONSTRAINT announcements_pkey PRIMARY KEY (id);


--
-- Name: answers_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY answers
    ADD CONSTRAINT answers_pkey PRIMARY KEY (id);


--
-- Name: artwork_uploads_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY artwork_uploads
    ADD CONSTRAINT artwork_uploads_pkey PRIMARY KEY (id);


--
-- Name: character_proxies_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY character_proxies
    ADD CONSTRAINT character_proxies_pkey PRIMARY KEY (id);


--
-- Name: characters_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY characters
    ADD CONSTRAINT characters_pkey PRIMARY KEY (id);


--
-- Name: comments_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY comments
    ADD CONSTRAINT comments_pkey PRIMARY KEY (id);


--
-- Name: communities_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY communities
    ADD CONSTRAINT communities_pkey PRIMARY KEY (id);


--
-- Name: community_applications_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY community_applications
    ADD CONSTRAINT community_applications_pkey PRIMARY KEY (id);


--
-- Name: community_games_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY community_games
    ADD CONSTRAINT community_games_pkey PRIMARY KEY (id);


--
-- Name: community_invites_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY community_invites
    ADD CONSTRAINT community_invites_pkey PRIMARY KEY (id);


--
-- Name: community_plan_upgrades_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY community_plan_upgrades
    ADD CONSTRAINT community_plan_upgrades_pkey PRIMARY KEY (id);


--
-- Name: community_plans_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY community_plans
    ADD CONSTRAINT community_plans_pkey PRIMARY KEY (id);


--
-- Name: community_profiles_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY community_profiles
    ADD CONSTRAINT community_profiles_pkey PRIMARY KEY (id);


--
-- Name: community_upgrades_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY community_upgrades
    ADD CONSTRAINT community_upgrades_pkey PRIMARY KEY (id);


--
-- Name: custom_forms_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY custom_forms
    ADD CONSTRAINT custom_forms_pkey PRIMARY KEY (id);


--
-- Name: delayed_jobs_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY delayed_jobs
    ADD CONSTRAINT delayed_jobs_pkey PRIMARY KEY (id);


--
-- Name: discussion_spaces_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY discussion_spaces
    ADD CONSTRAINT discussion_spaces_pkey PRIMARY KEY (id);


--
-- Name: discussions_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY discussions
    ADD CONSTRAINT discussions_pkey PRIMARY KEY (id);


--
-- Name: document_acceptances_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY document_acceptances
    ADD CONSTRAINT document_acceptances_pkey PRIMARY KEY (id);


--
-- Name: documents_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY documents
    ADD CONSTRAINT documents_pkey PRIMARY KEY (id);


--
-- Name: events_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY events
    ADD CONSTRAINT events_pkey PRIMARY KEY (id);


--
-- Name: folders_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY folders
    ADD CONSTRAINT folders_pkey PRIMARY KEY (id);


--
-- Name: games_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY games
    ADD CONSTRAINT games_pkey PRIMARY KEY (id);


--
-- Name: invites_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY invites
    ADD CONSTRAINT invites_pkey PRIMARY KEY (id);


--
-- Name: invoice_items_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY invoice_items
    ADD CONSTRAINT invoice_items_pkey PRIMARY KEY (id);


--
-- Name: invoices_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY invoices
    ADD CONSTRAINT invoices_pkey PRIMARY KEY (id);


--
-- Name: message_associations_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY message_associations
    ADD CONSTRAINT message_associations_pkey PRIMARY KEY (id);


--
-- Name: messages_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY messages
    ADD CONSTRAINT messages_pkey PRIMARY KEY (id);


--
-- Name: minecraft_characters_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY minecraft_characters
    ADD CONSTRAINT minecraft_characters_pkey PRIMARY KEY (id);


--
-- Name: minecrafts_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY minecrafts
    ADD CONSTRAINT minecrafts_pkey PRIMARY KEY (id);


--
-- Name: page_spaces_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY page_spaces
    ADD CONSTRAINT page_spaces_pkey PRIMARY KEY (id);


--
-- Name: pages_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY pages
    ADD CONSTRAINT pages_pkey PRIMARY KEY (id);


--
-- Name: permission_defaults_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY permission_defaults
    ADD CONSTRAINT permission_defaults_pkey PRIMARY KEY (id);


--
-- Name: permissions_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY permissions
    ADD CONSTRAINT permissions_pkey PRIMARY KEY (id);


--
-- Name: played_games_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY played_games
    ADD CONSTRAINT played_games_pkey PRIMARY KEY (id);


--
-- Name: predefined_answers_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY predefined_answers
    ADD CONSTRAINT predefined_answers_pkey PRIMARY KEY (id);


--
-- Name: questions_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY questions
    ADD CONSTRAINT questions_pkey PRIMARY KEY (id);


--
-- Name: roles_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY roles
    ADD CONSTRAINT roles_pkey PRIMARY KEY (id);


--
-- Name: roster_assignments_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY roster_assignments
    ADD CONSTRAINT roster_assignments_pkey PRIMARY KEY (id);


--
-- Name: site_configurations_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY site_configurations
    ADD CONSTRAINT site_configurations_pkey PRIMARY KEY (id);


--
-- Name: submissions_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY submissions
    ADD CONSTRAINT submissions_pkey PRIMARY KEY (id);


--
-- Name: support_comments_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY support_comments
    ADD CONSTRAINT support_comments_pkey PRIMARY KEY (id);


--
-- Name: support_tickets_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY support_tickets
    ADD CONSTRAINT support_tickets_pkey PRIMARY KEY (id);


--
-- Name: supported_games_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY supported_games
    ADD CONSTRAINT supported_games_pkey PRIMARY KEY (id);


--
-- Name: swtor_characters_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY swtor_characters
    ADD CONSTRAINT swtor_characters_pkey PRIMARY KEY (id);


--
-- Name: swtors_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY swtors
    ADD CONSTRAINT swtors_pkey PRIMARY KEY (id);


--
-- Name: themes_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY themes
    ADD CONSTRAINT themes_pkey PRIMARY KEY (id);


--
-- Name: user_profiles_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY user_profiles
    ADD CONSTRAINT user_profiles_pkey PRIMARY KEY (id);


--
-- Name: users_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: view_logs_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY view_logs
    ADD CONSTRAINT view_logs_pkey PRIMARY KEY (id);


--
-- Name: wow_characters_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY wow_characters
    ADD CONSTRAINT wow_characters_pkey PRIMARY KEY (id);


--
-- Name: wows_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY wows
    ADD CONSTRAINT wows_pkey PRIMARY KEY (id);


--
-- Name: community_games_info; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX community_games_info ON community_games USING gin (info);


--
-- Name: delayed_jobs_priority; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX delayed_jobs_priority ON delayed_jobs USING btree (priority, run_at);


--
-- Name: games_info; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX games_info ON games USING gin (info);


--
-- Name: habtm_cproxy_app_app_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX habtm_cproxy_app_app_id ON character_proxies_community_applications USING btree (community_application_id);


--
-- Name: habtm_cproxy_app_proxy_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX habtm_cproxy_app_proxy_id ON character_proxies_community_applications USING btree (character_proxy_id);


--
-- Name: index_acknowledgements_on_announcement_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_acknowledgements_on_announcement_id ON acknowledgements USING btree (announcement_id);


--
-- Name: index_acknowledgements_on_community_profile_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_acknowledgements_on_community_profile_id ON acknowledgements USING btree (community_profile_id);


--
-- Name: index_active_admin_comments_on_author_type_and_author_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_active_admin_comments_on_author_type_and_author_id ON active_admin_comments USING btree (author_type, author_id);


--
-- Name: index_active_admin_comments_on_namespace; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_active_admin_comments_on_namespace ON active_admin_comments USING btree (namespace);


--
-- Name: index_activities_on_community_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_activities_on_community_id ON activities USING btree (community_id);


--
-- Name: index_activities_on_target_type_and_target_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_activities_on_target_type_and_target_id ON activities USING btree (target_type, target_id);


--
-- Name: index_activities_on_user_profile_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_activities_on_user_profile_id ON activities USING btree (user_profile_id);


--
-- Name: index_admin_notes_on_resource_type_and_resource_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_admin_notes_on_resource_type_and_resource_id ON active_admin_comments USING btree (resource_type, resource_id);


--
-- Name: index_admin_users_on_email; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_admin_users_on_email ON admin_users USING btree (email);


--
-- Name: index_admin_users_on_reset_password_token; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_admin_users_on_reset_password_token ON admin_users USING btree (reset_password_token);


--
-- Name: index_announcements_on_character_proxy_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_announcements_on_character_proxy_id ON announcements USING btree (character_proxy_id);


--
-- Name: index_announcements_on_community_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_announcements_on_community_id ON announcements USING btree (community_id);


--
-- Name: index_announcements_on_supported_game_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_announcements_on_supported_game_id ON announcements USING btree (supported_game_id);


--
-- Name: index_announcements_on_user_profile_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_announcements_on_user_profile_id ON announcements USING btree (user_profile_id);


--
-- Name: index_answers_on_submission_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_answers_on_submission_id ON answers USING btree (submission_id);


--
-- Name: index_artwork_uploads_on_document_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_artwork_uploads_on_document_id ON artwork_uploads USING btree (document_id);


--
-- Name: index_character_proxies_on_user_profile_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_character_proxies_on_user_profile_id ON character_proxies USING btree (user_profile_id);


--
-- Name: index_comments_on_character_proxy_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_comments_on_character_proxy_id ON comments USING btree (character_proxy_id);


--
-- Name: index_comments_on_commentable_type_and_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_comments_on_commentable_type_and_id ON comments USING btree (commentable_type, commentable_id);


--
-- Name: index_comments_on_community_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_comments_on_community_id ON comments USING btree (community_id);


--
-- Name: index_comments_on_user_profile_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_comments_on_user_profile_id ON comments USING btree (user_profile_id);


--
-- Name: index_comments_original_commentable; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_comments_original_commentable ON comments USING btree (original_commentable_id, original_commentable_type);


--
-- Name: index_communities_on_admin_profile_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_communities_on_admin_profile_id ON communities USING btree (admin_profile_id);


--
-- Name: index_communities_on_community_application_form_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_communities_on_community_application_form_id ON communities USING btree (community_application_form_id);


--
-- Name: index_communities_on_home_page_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_communities_on_home_page_id ON communities USING btree (home_page_id);


--
-- Name: index_communities_on_member_role_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_communities_on_member_role_id ON communities USING btree (member_role_id);


--
-- Name: index_communities_on_name; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_communities_on_name ON communities USING btree (name);


--
-- Name: index_communities_on_theme_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_communities_on_theme_id ON communities USING btree (theme_id);


--
-- Name: index_community_applications_on_community_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_community_applications_on_community_id ON community_applications USING btree (community_id);


--
-- Name: index_community_applications_on_status_changer_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_community_applications_on_status_changer_id ON community_applications USING btree (status_changer_id);


--
-- Name: index_community_applications_on_submission_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_community_applications_on_submission_id ON community_applications USING btree (submission_id);


--
-- Name: index_community_applications_on_user_profile_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_community_applications_on_user_profile_id ON community_applications USING btree (user_profile_id);


--
-- Name: index_community_games_on_community_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_community_games_on_community_id ON community_games USING btree (community_id);


--
-- Name: index_community_games_on_game_announcement_space_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_community_games_on_game_announcement_space_id ON community_games USING btree (game_announcement_space_id);


--
-- Name: index_community_games_on_game_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_community_games_on_game_id ON community_games USING btree (game_id);


--
-- Name: index_community_invites_on_applicant_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_community_invites_on_applicant_id ON community_invites USING btree (applicant_id);


--
-- Name: index_community_invites_on_community_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_community_invites_on_community_id ON community_invites USING btree (community_id);


--
-- Name: index_community_invites_on_sponsor_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_community_invites_on_sponsor_id ON community_invites USING btree (sponsor_id);


--
-- Name: index_community_plan_upgrades_on_community_plan_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_community_plan_upgrades_on_community_plan_id ON community_plan_upgrades USING btree (community_plan_id);


--
-- Name: index_community_plan_upgrades_on_community_upgrade_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_community_plan_upgrades_on_community_upgrade_id ON community_plan_upgrades USING btree (community_upgrade_id);


--
-- Name: index_community_profiles_on_community_application_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_community_profiles_on_community_application_id ON community_profiles USING btree (community_application_id);


--
-- Name: index_community_profiles_on_community_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_community_profiles_on_community_id ON community_profiles USING btree (community_id);


--
-- Name: index_community_profiles_on_user_profile_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_community_profiles_on_user_profile_id ON community_profiles USING btree (user_profile_id);


--
-- Name: index_community_profiles_roles_on_community_profile_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_community_profiles_roles_on_community_profile_id ON community_profiles_roles USING btree (community_profile_id);


--
-- Name: index_community_profiles_roles_on_role_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_community_profiles_roles_on_role_id ON community_profiles_roles USING btree (role_id);


--
-- Name: index_custom_forms_on_community_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_custom_forms_on_community_id ON custom_forms USING btree (community_id);


--
-- Name: index_discussion_spaces_on_community_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_discussion_spaces_on_community_id ON discussion_spaces USING btree (community_id);


--
-- Name: index_discussion_spaces_on_game_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_discussion_spaces_on_game_id ON discussion_spaces USING btree (supported_game_id);


--
-- Name: index_discussions_on_character_proxy_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_discussions_on_character_proxy_id ON discussions USING btree (character_proxy_id);


--
-- Name: index_discussions_on_discussion_space_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_discussions_on_discussion_space_id ON discussions USING btree (discussion_space_id);


--
-- Name: index_discussions_on_user_profile_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_discussions_on_user_profile_id ON discussions USING btree (user_profile_id);


--
-- Name: index_document_acceptances_on_document_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_document_acceptances_on_document_id ON document_acceptances USING btree (document_id);


--
-- Name: index_document_acceptances_on_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_document_acceptances_on_user_id ON document_acceptances USING btree (user_id);


--
-- Name: index_events_on_community_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_events_on_community_id ON events USING btree (community_id);


--
-- Name: index_events_on_creator_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_events_on_creator_id ON events USING btree (creator_id);


--
-- Name: index_events_on_supported_game_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_events_on_supported_game_id ON events USING btree (supported_game_id);


--
-- Name: index_folders_on_user_profile_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_folders_on_user_profile_id ON folders USING btree (user_profile_id);


--
-- Name: index_invites_on_character_proxy_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_invites_on_character_proxy_id ON invites USING btree (character_proxy_id);


--
-- Name: index_invites_on_event_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_invites_on_event_id ON invites USING btree (event_id);


--
-- Name: index_invites_on_user_profile_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_invites_on_user_profile_id ON invites USING btree (user_profile_id);


--
-- Name: index_message_associations_on_folder_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_message_associations_on_folder_id ON message_associations USING btree (folder_id);


--
-- Name: index_message_associations_on_message_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_message_associations_on_message_id ON message_associations USING btree (message_id);


--
-- Name: index_message_associations_on_recipient_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_message_associations_on_recipient_id ON message_associations USING btree (recipient_id);


--
-- Name: index_messages_on_author_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_messages_on_author_id ON messages USING btree (author_id);


--
-- Name: index_page_spaces_on_community_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_page_spaces_on_community_id ON page_spaces USING btree (community_id);


--
-- Name: index_page_spaces_on_game_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_page_spaces_on_game_id ON page_spaces USING btree (supported_game_id);


--
-- Name: index_pages_on_page_space_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_pages_on_page_space_id ON pages USING btree (page_space_id);


--
-- Name: index_permission_defaults_on_role_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_permission_defaults_on_role_id ON permission_defaults USING btree (role_id);


--
-- Name: index_permissions_on_role_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_permissions_on_role_id ON permissions USING btree (role_id);


--
-- Name: index_predefined_answers_on_select_question_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_predefined_answers_on_select_question_id ON predefined_answers USING btree (question_id);


--
-- Name: index_proxies_on_character_type_and_character_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_proxies_on_character_type_and_character_id ON character_proxies USING btree (character_type, character_id);


--
-- Name: index_questions_on_custom_form_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_questions_on_custom_form_id ON questions USING btree (custom_form_id);


--
-- Name: index_roles_on_community_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_roles_on_community_id ON roles USING btree (community_id);


--
-- Name: index_roster_assignments_on_character_proxy_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_roster_assignments_on_character_proxy_id ON roster_assignments USING btree (character_proxy_id);


--
-- Name: index_roster_assignments_on_community_profile_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_roster_assignments_on_community_profile_id ON roster_assignments USING btree (community_profile_id);


--
-- Name: index_roster_assignments_on_supported_game_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_roster_assignments_on_supported_game_id ON roster_assignments USING btree (supported_game_id);


--
-- Name: index_submissions_on_custom_form_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_submissions_on_custom_form_id ON submissions USING btree (custom_form_id);


--
-- Name: index_submissions_on_user_profile_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_submissions_on_user_profile_id ON submissions USING btree (user_profile_id);


--
-- Name: index_support_comments_on_admin_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_support_comments_on_admin_user_id ON support_comments USING btree (admin_user_id);


--
-- Name: index_support_comments_on_support_ticket_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_support_comments_on_support_ticket_id ON support_comments USING btree (support_ticket_id);


--
-- Name: index_support_comments_on_user_profile_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_support_comments_on_user_profile_id ON support_comments USING btree (user_profile_id);


--
-- Name: index_support_tickets_on_admin_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_support_tickets_on_admin_user_id ON support_tickets USING btree (admin_user_id);


--
-- Name: index_support_tickets_on_user_profile_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_support_tickets_on_user_profile_id ON support_tickets USING btree (user_profile_id);


--
-- Name: index_supported_games_on_community_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_supported_games_on_community_id ON supported_games USING btree (community_id);


--
-- Name: index_supported_games_on_game_announcement_space_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_supported_games_on_game_announcement_space_id ON supported_games USING btree (game_announcement_space_id);


--
-- Name: index_supported_games_on_game_id_and_game_type; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_supported_games_on_game_id_and_game_type ON supported_games USING btree (game_id, game_type);


--
-- Name: index_swtor_characters_on_game_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_swtor_characters_on_game_id ON swtor_characters USING btree (swtor_id);


--
-- Name: index_user_profiles_on_display_name; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_user_profiles_on_display_name ON user_profiles USING btree (display_name);


--
-- Name: index_user_profiles_on_location; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_user_profiles_on_location ON user_profiles USING btree (location);


--
-- Name: index_user_profiles_on_slug; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_user_profiles_on_slug ON user_profiles USING btree (slug);


--
-- Name: index_users_on_confirmation_token; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_users_on_confirmation_token ON users USING btree (confirmation_token);


--
-- Name: index_users_on_email; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_users_on_email ON users USING btree (email);


--
-- Name: index_users_on_reset_password_token; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_users_on_reset_password_token ON users USING btree (reset_password_token);


--
-- Name: index_users_on_unlock_token; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_users_on_unlock_token ON users USING btree (unlock_token);


--
-- Name: index_users_on_user_profile_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_users_on_user_profile_id ON users USING btree (user_profile_id);


--
-- Name: index_view_logs_on_user_profile_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_view_logs_on_user_profile_id ON view_logs USING btree (user_profile_id);


--
-- Name: index_view_logs_on_view_loggable_type_and_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_view_logs_on_view_loggable_type_and_id ON view_logs USING btree (view_loggable_type, view_loggable_id);


--
-- Name: index_wow_characters_on_game_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_wow_characters_on_game_id ON wow_characters USING btree (wow_id);


--
-- Name: short_com_announcement_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX short_com_announcement_id ON communities USING btree (community_announcement_space_id);


--
-- Name: unique_schema_migrations; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX unique_schema_migrations ON schema_migrations USING btree (version);


--
-- PostgreSQL database dump complete
--

INSERT INTO schema_migrations (version) VALUES ('20110827164012');

INSERT INTO schema_migrations (version) VALUES ('20110830014853');

INSERT INTO schema_migrations (version) VALUES ('20110830120715');

INSERT INTO schema_migrations (version) VALUES ('20110903222731');

INSERT INTO schema_migrations (version) VALUES ('20110903224438');

INSERT INTO schema_migrations (version) VALUES ('20110903234513');

INSERT INTO schema_migrations (version) VALUES ('20110904004620');

INSERT INTO schema_migrations (version) VALUES ('20110904004847');

INSERT INTO schema_migrations (version) VALUES ('20110904005108');

INSERT INTO schema_migrations (version) VALUES ('20110904005601');

INSERT INTO schema_migrations (version) VALUES ('20110904064329');

INSERT INTO schema_migrations (version) VALUES ('20110904191538');

INSERT INTO schema_migrations (version) VALUES ('20110905184110');

INSERT INTO schema_migrations (version) VALUES ('20110905235628');

INSERT INTO schema_migrations (version) VALUES ('20110906004853');

INSERT INTO schema_migrations (version) VALUES ('20110909221054');

INSERT INTO schema_migrations (version) VALUES ('20110910171328');

INSERT INTO schema_migrations (version) VALUES ('20110910214429');

INSERT INTO schema_migrations (version) VALUES ('20110911010531');

INSERT INTO schema_migrations (version) VALUES ('20110911010554');

INSERT INTO schema_migrations (version) VALUES ('20110911022052');

INSERT INTO schema_migrations (version) VALUES ('20110912235626');

INSERT INTO schema_migrations (version) VALUES ('20110913000614');

INSERT INTO schema_migrations (version) VALUES ('20110913002424');

INSERT INTO schema_migrations (version) VALUES ('20110913003451');

INSERT INTO schema_migrations (version) VALUES ('20110913223448');

INSERT INTO schema_migrations (version) VALUES ('20110914221527');

INSERT INTO schema_migrations (version) VALUES ('20110915215719');

INSERT INTO schema_migrations (version) VALUES ('20110915220044');

INSERT INTO schema_migrations (version) VALUES ('20110915225312');

INSERT INTO schema_migrations (version) VALUES ('20110916154035');

INSERT INTO schema_migrations (version) VALUES ('20110917210835');

INSERT INTO schema_migrations (version) VALUES ('20110917220557');

INSERT INTO schema_migrations (version) VALUES ('20110917220627');

INSERT INTO schema_migrations (version) VALUES ('20110917220702');

INSERT INTO schema_migrations (version) VALUES ('20110917220734');

INSERT INTO schema_migrations (version) VALUES ('20110917220800');

INSERT INTO schema_migrations (version) VALUES ('20110917234448');

INSERT INTO schema_migrations (version) VALUES ('20110918000204');

INSERT INTO schema_migrations (version) VALUES ('20110918001519');

INSERT INTO schema_migrations (version) VALUES ('20110919220754');

INSERT INTO schema_migrations (version) VALUES ('20110924204002');

INSERT INTO schema_migrations (version) VALUES ('20110924205005');

INSERT INTO schema_migrations (version) VALUES ('20110924205243');

INSERT INTO schema_migrations (version) VALUES ('20110924225442');

INSERT INTO schema_migrations (version) VALUES ('20110924225513');

INSERT INTO schema_migrations (version) VALUES ('20110927202555');

INSERT INTO schema_migrations (version) VALUES ('20110927203012');

INSERT INTO schema_migrations (version) VALUES ('20111001022536');

INSERT INTO schema_migrations (version) VALUES ('20111001022729');

INSERT INTO schema_migrations (version) VALUES ('20111001023510');

INSERT INTO schema_migrations (version) VALUES ('20111003171428');

INSERT INTO schema_migrations (version) VALUES ('20111003171533');

INSERT INTO schema_migrations (version) VALUES ('20111008212727');

INSERT INTO schema_migrations (version) VALUES ('20111012220327');

INSERT INTO schema_migrations (version) VALUES ('20111014112341');

INSERT INTO schema_migrations (version) VALUES ('20111014112342');

INSERT INTO schema_migrations (version) VALUES ('20111014182327');

INSERT INTO schema_migrations (version) VALUES ('20111025191232');

INSERT INTO schema_migrations (version) VALUES ('20111025193616');

INSERT INTO schema_migrations (version) VALUES ('20111029143639');

INSERT INTO schema_migrations (version) VALUES ('20111102205241');

INSERT INTO schema_migrations (version) VALUES ('20111104194023');

INSERT INTO schema_migrations (version) VALUES ('20111105015838');

INSERT INTO schema_migrations (version) VALUES ('20111106010007');

INSERT INTO schema_migrations (version) VALUES ('20111108201332');

INSERT INTO schema_migrations (version) VALUES ('20111112175520');

INSERT INTO schema_migrations (version) VALUES ('20111114200717');

INSERT INTO schema_migrations (version) VALUES ('20111114203148');

INSERT INTO schema_migrations (version) VALUES ('20111116231431');

INSERT INTO schema_migrations (version) VALUES ('20111119221818');

INSERT INTO schema_migrations (version) VALUES ('20111119222146');

INSERT INTO schema_migrations (version) VALUES ('20111119222436');

INSERT INTO schema_migrations (version) VALUES ('20111119222941');

INSERT INTO schema_migrations (version) VALUES ('20111119223021');

INSERT INTO schema_migrations (version) VALUES ('20111119233558');

INSERT INTO schema_migrations (version) VALUES ('20111119235922');

INSERT INTO schema_migrations (version) VALUES ('20111119235953');

INSERT INTO schema_migrations (version) VALUES ('20111124024006');

INSERT INTO schema_migrations (version) VALUES ('20111124024057');

INSERT INTO schema_migrations (version) VALUES ('20111124200136');

INSERT INTO schema_migrations (version) VALUES ('20111129035811');

INSERT INTO schema_migrations (version) VALUES ('20111130030729');

INSERT INTO schema_migrations (version) VALUES ('20111130213038');

INSERT INTO schema_migrations (version) VALUES ('20111203213439');

INSERT INTO schema_migrations (version) VALUES ('20111203232918');

INSERT INTO schema_migrations (version) VALUES ('20111204203436');

INSERT INTO schema_migrations (version) VALUES ('20111204235701');

INSERT INTO schema_migrations (version) VALUES ('20111207035159');

INSERT INTO schema_migrations (version) VALUES ('20111207225904');

INSERT INTO schema_migrations (version) VALUES ('20111207233535');

INSERT INTO schema_migrations (version) VALUES ('20111208190004');

INSERT INTO schema_migrations (version) VALUES ('20111209035256');

INSERT INTO schema_migrations (version) VALUES ('20111209192406');

INSERT INTO schema_migrations (version) VALUES ('20111210200915');

INSERT INTO schema_migrations (version) VALUES ('20111212223626');

INSERT INTO schema_migrations (version) VALUES ('20111214004238');

INSERT INTO schema_migrations (version) VALUES ('20111216044652');

INSERT INTO schema_migrations (version) VALUES ('20120103224945');

INSERT INTO schema_migrations (version) VALUES ('20120111173010');

INSERT INTO schema_migrations (version) VALUES ('20120112001250');

INSERT INTO schema_migrations (version) VALUES ('20120113023706');

INSERT INTO schema_migrations (version) VALUES ('20120114234942');

INSERT INTO schema_migrations (version) VALUES ('20120124211358');

INSERT INTO schema_migrations (version) VALUES ('20120124231558');

INSERT INTO schema_migrations (version) VALUES ('20120124234803');

INSERT INTO schema_migrations (version) VALUES ('20120125004533');

INSERT INTO schema_migrations (version) VALUES ('20120126005942');

INSERT INTO schema_migrations (version) VALUES ('20120130222958');

INSERT INTO schema_migrations (version) VALUES ('20120131022151');

INSERT INTO schema_migrations (version) VALUES ('20120201231942');

INSERT INTO schema_migrations (version) VALUES ('20120201232049');

INSERT INTO schema_migrations (version) VALUES ('20120204200527');

INSERT INTO schema_migrations (version) VALUES ('20120207220623');

INSERT INTO schema_migrations (version) VALUES ('20120208222735');

INSERT INTO schema_migrations (version) VALUES ('20120223194535');

INSERT INTO schema_migrations (version) VALUES ('20120301214532');

INSERT INTO schema_migrations (version) VALUES ('20120301235122');

INSERT INTO schema_migrations (version) VALUES ('20120302234720');

INSERT INTO schema_migrations (version) VALUES ('20120308174339');

INSERT INTO schema_migrations (version) VALUES ('20120308225105');

INSERT INTO schema_migrations (version) VALUES ('20120308225154');

INSERT INTO schema_migrations (version) VALUES ('20120308234217');

INSERT INTO schema_migrations (version) VALUES ('20120308235947');

INSERT INTO schema_migrations (version) VALUES ('20120312182905');

INSERT INTO schema_migrations (version) VALUES ('20120312183025');

INSERT INTO schema_migrations (version) VALUES ('20120313214055');

INSERT INTO schema_migrations (version) VALUES ('20120313220822');

INSERT INTO schema_migrations (version) VALUES ('20120314202015');

INSERT INTO schema_migrations (version) VALUES ('20120314211702');

INSERT INTO schema_migrations (version) VALUES ('20120317175502');

INSERT INTO schema_migrations (version) VALUES ('20120317181635');

INSERT INTO schema_migrations (version) VALUES ('20120319160929');

INSERT INTO schema_migrations (version) VALUES ('20120709170310');

INSERT INTO schema_migrations (version) VALUES ('20120710173951');

INSERT INTO schema_migrations (version) VALUES ('20120714180027');

INSERT INTO schema_migrations (version) VALUES ('20120803181418');

INSERT INTO schema_migrations (version) VALUES ('20120808172622');

INSERT INTO schema_migrations (version) VALUES ('20120811200813');

INSERT INTO schema_migrations (version) VALUES ('20120827204016');

INSERT INTO schema_migrations (version) VALUES ('20120828180441');

INSERT INTO schema_migrations (version) VALUES ('20120828182319');

INSERT INTO schema_migrations (version) VALUES ('20120828231438');

INSERT INTO schema_migrations (version) VALUES ('20120829184423');

INSERT INTO schema_migrations (version) VALUES ('20120829215519');

INSERT INTO schema_migrations (version) VALUES ('20120829222330');

INSERT INTO schema_migrations (version) VALUES ('20120905182018');

INSERT INTO schema_migrations (version) VALUES ('20120915165411');

INSERT INTO schema_migrations (version) VALUES ('20120915165905');

INSERT INTO schema_migrations (version) VALUES ('20121002181729');

INSERT INTO schema_migrations (version) VALUES ('20121003230119');

INSERT INTO schema_migrations (version) VALUES ('20121006171544');

INSERT INTO schema_migrations (version) VALUES ('20121006194335');

INSERT INTO schema_migrations (version) VALUES ('20121008184959');

INSERT INTO schema_migrations (version) VALUES ('20121010204632');

INSERT INTO schema_migrations (version) VALUES ('20121010212532');

INSERT INTO schema_migrations (version) VALUES ('20121010212557');

INSERT INTO schema_migrations (version) VALUES ('20121010212733');

INSERT INTO schema_migrations (version) VALUES ('20121012183442');

INSERT INTO schema_migrations (version) VALUES ('20121015181727');

INSERT INTO schema_migrations (version) VALUES ('20121015223025');

INSERT INTO schema_migrations (version) VALUES ('20121016172830');

INSERT INTO schema_migrations (version) VALUES ('20121019181401');

INSERT INTO schema_migrations (version) VALUES ('20121019181657');

INSERT INTO schema_migrations (version) VALUES ('20121019194723');

INSERT INTO schema_migrations (version) VALUES ('20121020040743');

INSERT INTO schema_migrations (version) VALUES ('20121020211102');

INSERT INTO schema_migrations (version) VALUES ('20121021060158');

INSERT INTO schema_migrations (version) VALUES ('20121022184902');

INSERT INTO schema_migrations (version) VALUES ('20121022230849');

INSERT INTO schema_migrations (version) VALUES ('20121029182236');

INSERT INTO schema_migrations (version) VALUES ('20121029182517');

INSERT INTO schema_migrations (version) VALUES ('20121029184447');

INSERT INTO schema_migrations (version) VALUES ('20121029185503');

INSERT INTO schema_migrations (version) VALUES ('20121029205055');

INSERT INTO schema_migrations (version) VALUES ('20121029205254');

INSERT INTO schema_migrations (version) VALUES ('20121029205304');

INSERT INTO schema_migrations (version) VALUES ('20121029205340');

INSERT INTO schema_migrations (version) VALUES ('20121029205434');

INSERT INTO schema_migrations (version) VALUES ('20121029205550');

INSERT INTO schema_migrations (version) VALUES ('20121029205634');

INSERT INTO schema_migrations (version) VALUES ('20121030184039');

INSERT INTO schema_migrations (version) VALUES ('20121030195039');

INSERT INTO schema_migrations (version) VALUES ('20121030195101');

INSERT INTO schema_migrations (version) VALUES ('20121030220803');

INSERT INTO schema_migrations (version) VALUES ('20121031182416');

INSERT INTO schema_migrations (version) VALUES ('20121031182433');

INSERT INTO schema_migrations (version) VALUES ('20121101230703');

INSERT INTO schema_migrations (version) VALUES ('20121103155119');

INSERT INTO schema_migrations (version) VALUES ('20121103155519');

INSERT INTO schema_migrations (version) VALUES ('20121103160030');

INSERT INTO schema_migrations (version) VALUES ('20121103162800');

INSERT INTO schema_migrations (version) VALUES ('20121103194131');

INSERT INTO schema_migrations (version) VALUES ('20121103195326');

INSERT INTO schema_migrations (version) VALUES ('20121105194215');

INSERT INTO schema_migrations (version) VALUES ('20121113203319');

INSERT INTO schema_migrations (version) VALUES ('20121113203332');

INSERT INTO schema_migrations (version) VALUES ('20121206191144');