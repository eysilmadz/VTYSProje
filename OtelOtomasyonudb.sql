--
-- PostgreSQL database dump
--

-- Dumped from database version 14.5
-- Dumped by pg_dump version 15rc2

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: OtelOtomasyonudb; Type: DATABASE; Schema: -; Owner: postgres
--

CREATE DATABASE "OtelOtomasyonudb" WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'Turkish_Turkey.1254';


ALTER DATABASE "OtelOtomasyonudb" OWNER TO postgres;

\connect "OtelOtomasyonudb"

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: public; Type: SCHEMA; Schema: -; Owner: postgres
--

-- *not* creating schema, since initdb creates it


ALTER SCHEMA public OWNER TO postgres;

--
-- Name: aa(character varying, character varying, character varying, numeric, smallint); Type: PROCEDURE; Schema: public; Owner: postgres
--

CREATE PROCEDURE public.aa(IN kisiadi character varying, IN kisisoyadi character varying, IN tc character varying, IN hizmetlimaasi numeric, IN gorevlikat smallint)
    LANGUAGE plpgsql
    AS $$
BEGIN
	with first_insert as (
	   insert into kisi(kisino,kisiad,kisisoyad,kisitur,tckimlikno) 
	   values(nextval('kisi_kisino_seq'),kisiadi,kisisoyadi,2,tc) 
	   RETURNING kisino as kisi_kisino
	), 

	second_insert as (
	  insert into personel(personelno,personeltipi) 
	  values(nextval('personel_personelno_seq'),'hizmetli')
	  RETURNING personelno 
	)

	insert into hizmetli(hizmetlino,hizmetlimaas,calistigikat,otelno) 
	values(nextval('hizmetli_hizmetlino_seq'),hizmetlimaasi,gorevlikat,1);
END;
$$;


ALTER PROCEDURE public.aa(IN kisiadi character varying, IN kisisoyadi character varying, IN tc character varying, IN hizmetlimaasi numeric, IN gorevlikat smallint) OWNER TO postgres;

--
-- Name: ayrezervasyonfunc(character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.ayrezervasyonfunc(ay character varying) RETURNS TABLE(rezervasyonnum integer, musteriadi character varying, musterisoyadi character varying, odanum integer, rezervasyonucret double precision, otelgiris date, otelcikis date)
    LANGUAGE plpgsql
    AS $$
    begin 
        return QUERY
        select rezervasyonno,musterino,kisiad,kisisoyad,odano,giristarihi,cikistarihi,ucret,
            case 
                when MONTH(2023-01-31,2023-01-01) THEN ay='Ocak'
                when month(2023-02-28,2023-02-01) THEN ay='Şubat'
                when month(2023-03-31,2023-03-01) THEN ay='Mart'
                when month(2023-04-30,2023-04-01) THEN ay='Nisan'
                when month(2023-05-31,2023-05-01) THEN ay='Mayıs'
                when month(2023-06-30,2023-06-01) THEN ay='Haziran'
                when month(2023-07-31,2023-07-01) THEN ay='Temmuz'
                when month(2023-08-31,2023-08-01) THEN ay='Ağustos'
                when month(2023-09-30,2023-09-01) THEN ay='Eylül'
                when month(2023-10-31,2023-10-01) THEN ay='Ekim'
                when month(2023-11-30,2023-11-01) THEN ay='Kasım'
                when month(2023-12-31,2023-12-01) THEN ay='Aralık'
            end case;
    end;
$$;


ALTER FUNCTION public.ayrezervasyonfunc(ay character varying) OWNER TO postgres;

--
-- Name: gecesayisihesapla(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.gecesayisihesapla() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    UPDATE "takvim" SET "dolusure"= cikistarihi-giristarihi;
    RETURN NEW;
END;
$$;


ALTER FUNCTION public.gecesayisihesapla() OWNER TO postgres;

--
-- Name: gelirekle(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.gelirekle() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE kacgece integer;
        gunluk money;
        ucret money;
        toplamucret money;
    
BEGIN
    kacgece:=(select dolusure from takvim ORDER BY kayitno asc limit 1);
    gunluk:=(select gunlukfiyat from musteri ORDER BY kayitno asc limit 1);
    ucret:=(kacgece*gunluk);
    toplamucret:=(select sum(ucret) from rezervasyon);
 
    UPDATE "muhasebe" set "gelir"=toplamucret;
    RETURN NEW;
END;
$$;


ALTER FUNCTION public.gelirekle() OWNER TO postgres;

--
-- Name: giderekle(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.giderekle() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE maash money;
        maasd money;
        maasy money;
        toplamgider money;
BEGIN
    maash:=(select sum(hizmetlimaas) from hizmetli);
    maasd:=(select sum(danismanmaas) from danisman);
    maasy:=(select sum(yoneticimaas) from yonetici);
    
    UPDATE "muhasebe" SET "gider"=maash+maasd+maasy;
    RETURN NEW;
    
END;
$$;


ALTER FUNCTION public.giderekle() OWNER TO postgres;

--
-- Name: musteriarafunc(character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.musteriarafunc(kimlikno character varying) RETURNS TABLE(tckimlik character varying, musteriad character varying, musterisoyad character varying, odano integer)
    LANGUAGE plpgsql
    AS $$
    begin 
        RETURN QUERY
        SELECT
        tckimlikno,
        kisiad,
        kisisoyad,
        odano
        from "musteri"
        inner join "kisi" on "kisi"."kisino"="musteri"."musterino"
        inner join "rezervasyon" on "rezervasyon"."musterino"="musteri"."musterino"
        where tckimlikno=kimlikno;
    end;
$$;


ALTER FUNCTION public.musteriarafunc(kimlikno character varying) OWNER TO postgres;

--
-- Name: musterigetir(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.musterigetir() RETURNS TABLE(musterinum integer, musteriad character varying, musterisoyad character varying, rezervasyonnum integer)
    LANGUAGE plpgsql
    AS $$
begin
return query select kisino, kisiad, kisisoyad, rezervasyonno from musteri inner join kisi on kisi.kisino=musteri.musterino;
end;
$$;


ALTER FUNCTION public.musterigetir() OWNER TO postgres;

--
-- Name: odaara(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.odaara(parametre integer) RETURNS TABLE(odano integer, odakat smallint, kisisayisi smallint, gunlukfiyat money, odatur character varying, otelno integer)
    LANGUAGE plpgsql
    AS $$
BEGIN
	return query 
	Select
	"odano",
	"odakat",
	"kisisayisi",
	"gunlukfiyat",
	"odatur",
	"otelno"
from
	"oda"
where
	"odano"=parametre;
		
END;
$$;


ALTER FUNCTION public.odaara(parametre integer) OWNER TO postgres;

--
-- Name: odabilgiarafunc(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.odabilgiarafunc(numara integer) RETURNS TABLE("odanumarası" integer, "katnumarası" integer, kackisilik integer, gunfiyati double precision, odatipi character varying)
    LANGUAGE plpgsql
    AS $$
    BEGIN 
        RETURN QUERY
        SELECT
        odano,
        odakat,
        kisisayisi,
        gunlukfiyat,
        odatur
        FROM oda where odanumarası=numara;
    END;
    $$;


ALTER FUNCTION public.odabilgiarafunc(numara integer) OWNER TO postgres;

--
-- Name: odara(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.odara(idoda integer) RETURNS TABLE(odanum integer, kat smallint, kisisayi smallint, odacesid character varying, fiyat money)
    LANGUAGE plpgsql
    AS $$
begin
return query select odano,odakat,kisisayisi,odatur,gunlukfiyat,otelno from
oda
where odano = idoda;
end;
$$;


ALTER FUNCTION public.odara(idoda integer) OWNER TO postgres;

--
-- Name: ucrethesapla(); Type: PROCEDURE; Schema: public; Owner: postgres
--

CREATE PROCEDURE public.ucrethesapla()
    LANGUAGE plpgsql
    AS $$
DECLARE
    odagunfiyat float;
    gecesayisi integer;
    odaucret float;
BEGIN 
    odagunfiyat:=(select gunlukfiyat from oda);
    gecesayisi:=(select dolusure from takvim);
    LOOP
        odaucret:=odagunfiyat*gecesayisi;
        insert into rezervasyon(rezervasyonno,musterino,kayitno,odano,otelno,ucret)
        values (NEXTVAL('seqrezervasyonno'),rezervasyon.musterino,rezervasyon.kayitno,rezervasyon.odano,rezervasyon.otelno,odaucret);
    end loop;
end;
$$;


ALTER PROCEDURE public.ucrethesapla() OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: adres; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.adres (
    adresno integer NOT NULL,
    ilno integer NOT NULL,
    ilceno integer NOT NULL
);


ALTER TABLE public.adres OWNER TO postgres;

--
-- Name: adres_adresno_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.adres_adresno_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.adres_adresno_seq OWNER TO postgres;

--
-- Name: adres_adresno_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.adres_adresno_seq OWNED BY public.adres.adresno;


--
-- Name: adres_ilceno_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.adres_ilceno_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.adres_ilceno_seq OWNER TO postgres;

--
-- Name: adres_ilceno_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.adres_ilceno_seq OWNED BY public.adres.ilceno;


--
-- Name: adres_ilno_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.adres_ilno_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.adres_ilno_seq OWNER TO postgres;

--
-- Name: adres_ilno_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.adres_ilno_seq OWNED BY public.adres.ilno;


--
-- Name: danisman; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.danisman (
    danismanno integer NOT NULL,
    otelno integer NOT NULL,
    danismanmaas numeric(18,2)
);


ALTER TABLE public.danisman OWNER TO postgres;

--
-- Name: danisman_danismanno_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.danisman_danismanno_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.danisman_danismanno_seq OWNER TO postgres;

--
-- Name: danisman_danismanno_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.danisman_danismanno_seq OWNED BY public.danisman.danismanno;


--
-- Name: danisman_otelno_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.danisman_otelno_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.danisman_otelno_seq OWNER TO postgres;

--
-- Name: danisman_otelno_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.danisman_otelno_seq OWNED BY public.danisman.otelno;


--
-- Name: il; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.il (
    ilno integer NOT NULL,
    ilad character varying(14) NOT NULL
);


ALTER TABLE public.il OWNER TO postgres;

--
-- Name: ilce; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.ilce (
    ilceno integer NOT NULL,
    ilcead character varying(20) NOT NULL
);


ALTER TABLE public.ilce OWNER TO postgres;

--
-- Name: iletisimBilgileri; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."iletisimBilgileri" (
    iletisimno integer NOT NULL,
    kisino integer NOT NULL,
    adresno smallint NOT NULL,
    telefon character varying(10) NOT NULL
);


ALTER TABLE public."iletisimBilgileri" OWNER TO postgres;

--
-- Name: kisi; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.kisi (
    kisino integer NOT NULL,
    tckimlikno character varying(11) NOT NULL,
    kisiad character varying(20),
    kisisoyad character varying(20),
    kisitur smallint NOT NULL
);


ALTER TABLE public.kisi OWNER TO postgres;

--
-- Name: danismanbilgipanel; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.danismanbilgipanel AS
 SELECT kisi.kisiad AS "Danışman Ad",
    kisi.kisisoyad AS "Danışman Soyad",
    kisi.tckimlikno AS "Danışman Tc",
    "iletisimBilgileri".telefon AS "Telefon",
    il.ilad AS "İl",
    ilce.ilcead AS "İlçe",
    danisman.danismanmaas AS "Danışman Maaşı"
   FROM (((((public.kisi
     JOIN public."iletisimBilgileri" ON ((kisi.kisino = "iletisimBilgileri".kisino)))
     JOIN public.adres ON (("iletisimBilgileri".adresno = adres.adresno)))
     JOIN public.il ON ((adres.ilno = il.ilno)))
     JOIN public.ilce ON ((adres.ilceno = ilce.ilceno)))
     JOIN public.danisman ON ((kisi.kisino = danisman.danismanno)));


ALTER TABLE public.danismanbilgipanel OWNER TO postgres;

--
-- Name: hizmetli; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.hizmetli (
    hizmetlino integer NOT NULL,
    otelno integer NOT NULL,
    calistigikat smallint,
    hizmetlimaas numeric(18,2)
);


ALTER TABLE public.hizmetli OWNER TO postgres;

--
-- Name: hizmetli_hizmetlino_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.hizmetli_hizmetlino_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.hizmetli_hizmetlino_seq OWNER TO postgres;

--
-- Name: hizmetli_hizmetlino_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.hizmetli_hizmetlino_seq OWNED BY public.hizmetli.hizmetlino;


--
-- Name: hizmetli_otelno_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.hizmetli_otelno_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.hizmetli_otelno_seq OWNER TO postgres;

--
-- Name: hizmetli_otelno_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.hizmetli_otelno_seq OWNED BY public.hizmetli.otelno;


--
-- Name: hizmetlibilgipanel; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.hizmetlibilgipanel AS
 SELECT kisi.kisiad AS "Hizmetli Ad",
    kisi.kisisoyad AS "Hizmetli Soyad",
    kisi.tckimlikno AS "Hizmetli Tc",
    "iletisimBilgileri".telefon AS "Telefon",
    il.ilad AS "İl",
    ilce.ilcead AS "İlce",
    hizmetli.calistigikat AS "Çalıştığı Kat",
    hizmetli.hizmetlimaas AS "Hizmetli Maaşı"
   FROM (((((public.kisi
     JOIN public."iletisimBilgileri" ON ((kisi.kisino = "iletisimBilgileri".kisino)))
     JOIN public.adres ON (("iletisimBilgileri".adresno = adres.adresno)))
     JOIN public.il ON ((adres.ilno = il.ilno)))
     JOIN public.ilce ON ((adres.ilceno = ilce.ilceno)))
     JOIN public.hizmetli ON ((kisi.kisino = hizmetli.hizmetlino)));


ALTER TABLE public.hizmetlibilgipanel OWNER TO postgres;

--
-- Name: il_ilno_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.il_ilno_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.il_ilno_seq OWNER TO postgres;

--
-- Name: il_ilno_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.il_ilno_seq OWNED BY public.il.ilno;


--
-- Name: ilce_ilceno_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.ilce_ilceno_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.ilce_ilceno_seq OWNER TO postgres;

--
-- Name: ilce_ilceno_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.ilce_ilceno_seq OWNED BY public.ilce.ilceno;


--
-- Name: iletisimBilgileri_iletisimno_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."iletisimBilgileri_iletisimno_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."iletisimBilgileri_iletisimno_seq" OWNER TO postgres;

--
-- Name: iletisimBilgileri_iletisimno_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."iletisimBilgileri_iletisimno_seq" OWNED BY public."iletisimBilgileri".iletisimno;


--
-- Name: iletisimBilgileri_kisino_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."iletisimBilgileri_kisino_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."iletisimBilgileri_kisino_seq" OWNER TO postgres;

--
-- Name: iletisimBilgileri_kisino_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."iletisimBilgileri_kisino_seq" OWNED BY public."iletisimBilgileri".kisino;


--
-- Name: kisi_kisino_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.kisi_kisino_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.kisi_kisino_seq OWNER TO postgres;

--
-- Name: kisi_kisino_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.kisi_kisino_seq OWNED BY public.kisi.kisino;


--
-- Name: muhasebe; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.muhasebe (
    islemno integer NOT NULL,
    otelno integer NOT NULL,
    gelir money,
    gider money,
    kasadurum money
);


ALTER TABLE public.muhasebe OWNER TO postgres;

--
-- Name: muhasebe_islemno_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.muhasebe_islemno_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.muhasebe_islemno_seq OWNER TO postgres;

--
-- Name: muhasebe_islemno_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.muhasebe_islemno_seq OWNED BY public.muhasebe.islemno;


--
-- Name: muhasebe_otelno_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.muhasebe_otelno_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.muhasebe_otelno_seq OWNER TO postgres;

--
-- Name: muhasebe_otelno_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.muhasebe_otelno_seq OWNED BY public.muhasebe.otelno;


--
-- Name: otel; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.otel (
    otelno integer NOT NULL,
    otelad character varying(20) NOT NULL,
    otelyildiz smallint,
    oteltur character varying(15),
    adresno integer NOT NULL
);


ALTER TABLE public.otel OWNER TO postgres;

--
-- Name: muhasebebilgipanel; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.muhasebebilgipanel AS
 SELECT muhasebe.islemno AS "İşlem No",
    otel.otelad AS "Otel Adı",
    muhasebe.gelir AS "Gelir Bilgisi",
    muhasebe.gider AS "gider Bilgisi",
    muhasebe.kasadurum AS "Kasa"
   FROM (public.muhasebe
     JOIN public.otel ON ((otel.otelno = muhasebe.otelno)));


ALTER TABLE public.muhasebebilgipanel OWNER TO postgres;

--
-- Name: musteri; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.musteri (
    musterino integer NOT NULL,
    rezervasyonno integer NOT NULL
);


ALTER TABLE public.musteri OWNER TO postgres;

--
-- Name: musteri_musterino_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.musteri_musterino_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.musteri_musterino_seq OWNER TO postgres;

--
-- Name: musteri_musterino_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.musteri_musterino_seq OWNED BY public.musteri.musterino;


--
-- Name: musteri_rezervasyonno_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.musteri_rezervasyonno_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.musteri_rezervasyonno_seq OWNER TO postgres;

--
-- Name: musteri_rezervasyonno_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.musteri_rezervasyonno_seq OWNED BY public.musteri.rezervasyonno;


--
-- Name: oda; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.oda (
    odano integer NOT NULL,
    otelno integer NOT NULL,
    odakat smallint NOT NULL,
    gunlukfiyat money,
    kisisayisi smallint NOT NULL,
    odatur character varying(30),
    odaresim smallint
);


ALTER TABLE public.oda OWNER TO postgres;

--
-- Name: odaResim; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."odaResim" (
    odano integer NOT NULL,
    dosyayolu text
);


ALTER TABLE public."odaResim" OWNER TO postgres;

--
-- Name: odaResim_odano_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."odaResim_odano_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."odaResim_odano_seq" OWNER TO postgres;

--
-- Name: odaResim_odano_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."odaResim_odano_seq" OWNED BY public."odaResim".odano;


--
-- Name: oda_odano_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.oda_odano_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.oda_odano_seq OWNER TO postgres;

--
-- Name: oda_odano_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.oda_odano_seq OWNED BY public.oda.odano;


--
-- Name: oda_otelno_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.oda_otelno_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.oda_otelno_seq OWNER TO postgres;

--
-- Name: oda_otelno_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.oda_otelno_seq OWNED BY public.oda.otelno;


--
-- Name: otel_adresno_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.otel_adresno_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.otel_adresno_seq OWNER TO postgres;

--
-- Name: otel_adresno_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.otel_adresno_seq OWNED BY public.otel.adresno;


--
-- Name: otel_otelno_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.otel_otelno_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.otel_otelno_seq OWNER TO postgres;

--
-- Name: otel_otelno_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.otel_otelno_seq OWNED BY public.otel.otelno;


--
-- Name: otelbilgipanel; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.otelbilgipanel AS
 SELECT otel.otelad AS "Otel Adı",
    otel.otelyildiz AS "Yıldız Sayısı",
    otel.oteltur AS "Otel Türü",
    il.ilad AS "İl",
    ilce.ilcead AS "İlçe"
   FROM (((public.otel
     JOIN public.adres ON ((otel.adresno = adres.adresno)))
     JOIN public.il ON ((adres.ilno = il.ilno)))
     JOIN public.ilce ON ((adres.ilceno = ilce.ilceno)));


ALTER TABLE public.otelbilgipanel OWNER TO postgres;

--
-- Name: personel; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.personel (
    personelno integer NOT NULL,
    personeltipi text NOT NULL
);


ALTER TABLE public.personel OWNER TO postgres;

--
-- Name: personelResim; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."personelResim" (
    personelno integer NOT NULL,
    dosyayolu text
);


ALTER TABLE public."personelResim" OWNER TO postgres;

--
-- Name: personelResim_personelno_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."personelResim_personelno_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."personelResim_personelno_seq" OWNER TO postgres;

--
-- Name: personelResim_personelno_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."personelResim_personelno_seq" OWNED BY public."personelResim".personelno;


--
-- Name: personel_personelno_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.personel_personelno_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.personel_personelno_seq OWNER TO postgres;

--
-- Name: personel_personelno_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.personel_personelno_seq OWNED BY public.personel.personelno;


--
-- Name: rezervasyon; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.rezervasyon (
    rezervasyonno integer NOT NULL,
    otelno integer NOT NULL,
    odano integer NOT NULL,
    kayitno integer NOT NULL,
    musterino integer NOT NULL,
    ucret money
);


ALTER TABLE public.rezervasyon OWNER TO postgres;

--
-- Name: rezervasyon_kayitno_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.rezervasyon_kayitno_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.rezervasyon_kayitno_seq OWNER TO postgres;

--
-- Name: rezervasyon_kayitno_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.rezervasyon_kayitno_seq OWNED BY public.rezervasyon.kayitno;


--
-- Name: rezervasyon_musterino_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.rezervasyon_musterino_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.rezervasyon_musterino_seq OWNER TO postgres;

--
-- Name: rezervasyon_musterino_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.rezervasyon_musterino_seq OWNED BY public.rezervasyon.musterino;


--
-- Name: rezervasyon_odano_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.rezervasyon_odano_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.rezervasyon_odano_seq OWNER TO postgres;

--
-- Name: rezervasyon_odano_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.rezervasyon_odano_seq OWNED BY public.rezervasyon.odano;


--
-- Name: rezervasyon_otelno_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.rezervasyon_otelno_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.rezervasyon_otelno_seq OWNER TO postgres;

--
-- Name: rezervasyon_otelno_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.rezervasyon_otelno_seq OWNED BY public.rezervasyon.otelno;


--
-- Name: rezervasyon_rezervasyonno_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.rezervasyon_rezervasyonno_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.rezervasyon_rezervasyonno_seq OWNER TO postgres;

--
-- Name: rezervasyon_rezervasyonno_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.rezervasyon_rezervasyonno_seq OWNED BY public.rezervasyon.rezervasyonno;


--
-- Name: takvim; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.takvim (
    kayitno integer NOT NULL,
    giristarihi date,
    cikistarihi date,
    doluluk bit(1),
    dolusure integer
);


ALTER TABLE public.takvim OWNER TO postgres;

--
-- Name: rezervasyonbilgipanel; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.rezervasyonbilgipanel AS
 SELECT kisi.kisiad AS "Müşteri Ad",
    kisi.kisisoyad AS "Müşteri Soyad",
    "iletisimBilgileri".telefon AS "Telefon",
    oda.odano AS "Oda No",
    takvim.giristarihi AS "Giriş Tarihi",
    takvim.cikistarihi AS "Çıkış Tarihi",
    takvim.dolusure AS "Gece Sayısı",
    rezervasyon.ucret AS "Toplam Ücret"
   FROM ((((public.rezervasyon
     JOIN public."iletisimBilgileri" ON ((rezervasyon.musterino = "iletisimBilgileri".kisino)))
     JOIN public.kisi ON ((kisi.kisino = rezervasyon.musterino)))
     JOIN public.oda ON ((oda.odano = rezervasyon.odano)))
     JOIN public.takvim ON ((takvim.kayitno = rezervasyon.kayitno)));


ALTER TABLE public.rezervasyonbilgipanel OWNER TO postgres;

--
-- Name: seqadresno; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.seqadresno
    START WITH 16
    INCREMENT BY 1
    NO MINVALUE
    MAXVALUE 1000
    CACHE 2;


ALTER TABLE public.seqadresno OWNER TO postgres;

--
-- Name: seqilceno; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.seqilceno
    START WITH 16
    INCREMENT BY 1
    NO MINVALUE
    MAXVALUE 1000
    CACHE 2;


ALTER TABLE public.seqilceno OWNER TO postgres;

--
-- Name: seqiletisimno; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.seqiletisimno
    START WITH 36
    INCREMENT BY 1
    NO MINVALUE
    MAXVALUE 1000
    CACHE 2;


ALTER TABLE public.seqiletisimno OWNER TO postgres;

--
-- Name: seqilno; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.seqilno
    START WITH 11
    INCREMENT BY 1
    NO MINVALUE
    MAXVALUE 1000
    CACHE 2;


ALTER TABLE public.seqilno OWNER TO postgres;

--
-- Name: seqislemno; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.seqislemno
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    MAXVALUE 1000
    CACHE 2;


ALTER TABLE public.seqislemno OWNER TO postgres;

--
-- Name: seqkayitno; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.seqkayitno
    START WITH 4
    INCREMENT BY 1
    NO MINVALUE
    MAXVALUE 1000
    CACHE 2;


ALTER TABLE public.seqkayitno OWNER TO postgres;

--
-- Name: seqkisino; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.seqkisino
    START WITH 36
    INCREMENT BY 1
    NO MINVALUE
    MAXVALUE 1000
    CACHE 3;


ALTER TABLE public.seqkisino OWNER TO postgres;

--
-- Name: seqrezervasyonno; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.seqrezervasyonno
    START WITH 4
    INCREMENT BY 1
    NO MINVALUE
    MAXVALUE 1000
    CACHE 2;


ALTER TABLE public.seqrezervasyonno OWNER TO postgres;

--
-- Name: takvim_kayitno_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.takvim_kayitno_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.takvim_kayitno_seq OWNER TO postgres;

--
-- Name: takvim_kayitno_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.takvim_kayitno_seq OWNED BY public.takvim.kayitno;


--
-- Name: yonetici; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.yonetici (
    yoneticino integer NOT NULL,
    otelno integer NOT NULL,
    yoneticitur character varying(40) NOT NULL,
    yoneticimaas numeric(18,2),
    kullaniciadi text NOT NULL,
    sifre character varying(20) NOT NULL
);


ALTER TABLE public.yonetici OWNER TO postgres;

--
-- Name: yonetici_otelno_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.yonetici_otelno_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.yonetici_otelno_seq OWNER TO postgres;

--
-- Name: yonetici_otelno_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.yonetici_otelno_seq OWNED BY public.yonetici.otelno;


--
-- Name: yonetici_yoneticino_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.yonetici_yoneticino_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.yonetici_yoneticino_seq OWNER TO postgres;

--
-- Name: yonetici_yoneticino_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.yonetici_yoneticino_seq OWNED BY public.yonetici.yoneticino;


--
-- Name: yoneticibilgipanel; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.yoneticibilgipanel AS
 SELECT kisi.kisiad AS "Yönetici Ad",
    kisi.kisisoyad AS "Yönetici Soyad",
    yonetici.yoneticitur AS "yönetici Departmanı",
    "iletisimBilgileri".telefon AS "Telefon",
    il.ilad AS "İl",
    ilce.ilcead AS "İlçe"
   FROM (((((public.kisi
     JOIN public.yonetici ON ((yonetici.yoneticino = kisi.kisino)))
     JOIN public."iletisimBilgileri" ON ((kisi.kisino = "iletisimBilgileri".kisino)))
     JOIN public.adres ON (("iletisimBilgileri".adresno = adres.adresno)))
     JOIN public.il ON ((adres.ilno = il.ilno)))
     JOIN public.ilce ON ((adres.ilceno = ilce.ilceno)));


ALTER TABLE public.yoneticibilgipanel OWNER TO postgres;

--
-- Name: adres adresno; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.adres ALTER COLUMN adresno SET DEFAULT nextval('public.adres_adresno_seq'::regclass);


--
-- Name: adres ilno; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.adres ALTER COLUMN ilno SET DEFAULT nextval('public.adres_ilno_seq'::regclass);


--
-- Name: adres ilceno; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.adres ALTER COLUMN ilceno SET DEFAULT nextval('public.adres_ilceno_seq'::regclass);


--
-- Name: danisman danismanno; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.danisman ALTER COLUMN danismanno SET DEFAULT nextval('public.danisman_danismanno_seq'::regclass);


--
-- Name: danisman otelno; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.danisman ALTER COLUMN otelno SET DEFAULT nextval('public.danisman_otelno_seq'::regclass);


--
-- Name: hizmetli hizmetlino; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.hizmetli ALTER COLUMN hizmetlino SET DEFAULT nextval('public.hizmetli_hizmetlino_seq'::regclass);


--
-- Name: hizmetli otelno; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.hizmetli ALTER COLUMN otelno SET DEFAULT nextval('public.hizmetli_otelno_seq'::regclass);


--
-- Name: il ilno; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.il ALTER COLUMN ilno SET DEFAULT nextval('public.il_ilno_seq'::regclass);


--
-- Name: ilce ilceno; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ilce ALTER COLUMN ilceno SET DEFAULT nextval('public.ilce_ilceno_seq'::regclass);


--
-- Name: iletisimBilgileri iletisimno; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."iletisimBilgileri" ALTER COLUMN iletisimno SET DEFAULT nextval('public."iletisimBilgileri_iletisimno_seq"'::regclass);


--
-- Name: iletisimBilgileri kisino; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."iletisimBilgileri" ALTER COLUMN kisino SET DEFAULT nextval('public."iletisimBilgileri_kisino_seq"'::regclass);


--
-- Name: kisi kisino; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.kisi ALTER COLUMN kisino SET DEFAULT nextval('public.kisi_kisino_seq'::regclass);


--
-- Name: muhasebe islemno; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.muhasebe ALTER COLUMN islemno SET DEFAULT nextval('public.muhasebe_islemno_seq'::regclass);


--
-- Name: muhasebe otelno; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.muhasebe ALTER COLUMN otelno SET DEFAULT nextval('public.muhasebe_otelno_seq'::regclass);


--
-- Name: musteri musterino; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.musteri ALTER COLUMN musterino SET DEFAULT nextval('public.musteri_musterino_seq'::regclass);


--
-- Name: musteri rezervasyonno; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.musteri ALTER COLUMN rezervasyonno SET DEFAULT nextval('public.musteri_rezervasyonno_seq'::regclass);


--
-- Name: oda odano; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.oda ALTER COLUMN odano SET DEFAULT nextval('public.oda_odano_seq'::regclass);


--
-- Name: oda otelno; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.oda ALTER COLUMN otelno SET DEFAULT nextval('public.oda_otelno_seq'::regclass);


--
-- Name: odaResim odano; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."odaResim" ALTER COLUMN odano SET DEFAULT nextval('public."odaResim_odano_seq"'::regclass);


--
-- Name: otel otelno; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.otel ALTER COLUMN otelno SET DEFAULT nextval('public.otel_otelno_seq'::regclass);


--
-- Name: otel adresno; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.otel ALTER COLUMN adresno SET DEFAULT nextval('public.otel_adresno_seq'::regclass);


--
-- Name: personel personelno; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.personel ALTER COLUMN personelno SET DEFAULT nextval('public.personel_personelno_seq'::regclass);


--
-- Name: personelResim personelno; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."personelResim" ALTER COLUMN personelno SET DEFAULT nextval('public."personelResim_personelno_seq"'::regclass);


--
-- Name: rezervasyon rezervasyonno; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.rezervasyon ALTER COLUMN rezervasyonno SET DEFAULT nextval('public.rezervasyon_rezervasyonno_seq'::regclass);


--
-- Name: rezervasyon otelno; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.rezervasyon ALTER COLUMN otelno SET DEFAULT nextval('public.rezervasyon_otelno_seq'::regclass);


--
-- Name: rezervasyon odano; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.rezervasyon ALTER COLUMN odano SET DEFAULT nextval('public.rezervasyon_odano_seq'::regclass);


--
-- Name: rezervasyon kayitno; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.rezervasyon ALTER COLUMN kayitno SET DEFAULT nextval('public.rezervasyon_kayitno_seq'::regclass);


--
-- Name: rezervasyon musterino; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.rezervasyon ALTER COLUMN musterino SET DEFAULT nextval('public.rezervasyon_musterino_seq'::regclass);


--
-- Name: takvim kayitno; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.takvim ALTER COLUMN kayitno SET DEFAULT nextval('public.takvim_kayitno_seq'::regclass);


--
-- Name: yonetici yoneticino; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.yonetici ALTER COLUMN yoneticino SET DEFAULT nextval('public.yonetici_yoneticino_seq'::regclass);


--
-- Name: yonetici otelno; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.yonetici ALTER COLUMN otelno SET DEFAULT nextval('public.yonetici_otelno_seq'::regclass);


--
-- Data for Name: adres; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.adres (adresno, ilno, ilceno) VALUES
	(1, 1, 1),
	(2, 1, 14),
	(3, 2, 2),
	(4, 3, 3),
	(5, 3, 11),
	(6, 3, 15),
	(7, 4, 4),
	(8, 5, 5),
	(9, 6, 6),
	(10, 7, 7),
	(11, 7, 13),
	(12, 8, 8),
	(13, 9, 9),
	(14, 10, 10),
	(15, 10, 12);


--
-- Data for Name: danisman; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.danisman (danismanno, otelno, danismanmaas) VALUES
	(19, 1, 5550.00),
	(23, 1, 5550.00),
	(24, 1, 5550.00),
	(25, 1, 5550.00),
	(26, 1, 5550.00);


--
-- Data for Name: hizmetli; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.hizmetli (hizmetlino, otelno, calistigikat, hizmetlimaas) VALUES
	(20, 1, 0, 4890.00),
	(27, 1, 0, 4890.00),
	(28, 1, 1, 4890.00),
	(29, 1, 1, 4890.00),
	(30, 1, 1, 4890.00),
	(31, 1, 1, 4890.00),
	(32, 1, 2, 4890.00),
	(33, 1, 2, 4890.00),
	(34, 1, 2, 4890.00),
	(35, 1, 2, 4890.00);


--
-- Data for Name: il; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.il (ilno, ilad) VALUES
	(1, 'Ankara'),
	(2, 'Aksaray'),
	(3, 'İstanbul'),
	(5, 'Karaman'),
	(6, 'Samsun'),
	(7, 'Bolu'),
	(8, 'Sakarya'),
	(9, 'Amasya'),
	(10, 'Bursa'),
	(4, 'Bayburt');


--
-- Data for Name: ilce; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.ilce (ilceno, ilcead) VALUES
	(1, 'Çankaya'),
	(2, 'Aksaray Merkez'),
	(3, 'Kadıköy'),
	(4, 'Bayburt Merkez'),
	(5, 'Karaman Merkez'),
	(6, 'Çarşamba'),
	(7, 'Gerede'),
	(8, 'Serdivan'),
	(9, 'Merzifon'),
	(10, 'Yıldırım'),
	(11, 'Üsküdar'),
	(12, 'İznik'),
	(13, 'Bolu Merkez'),
	(14, 'Polatlı'),
	(15, 'Beyoğlu');


--
-- Data for Name: iletisimBilgileri; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public."iletisimBilgileri" (iletisimno, kisino, adresno, telefon) VALUES
	(1, 1, 12, '5452897563'),
	(2, 2, 4, '5453658475'),
	(3, 3, 3, '5432698574'),
	(4, 4, 6, '5452658934'),
	(5, 5, 5, '5365412875'),
	(6, 6, 9, '5327525522'),
	(7, 7, 2, '5685962425'),
	(8, 8, 7, '5474528693'),
	(9, 9, 8, '5314587759'),
	(10, 10, 11, '5475268956'),
	(11, 11, 11, '5257859633'),
	(12, 12, 13, '5442520026'),
	(13, 13, 5, '5365489632'),
	(14, 14, 14, '5455698752'),
	(15, 15, 1, '5078569585'),
	(16, 16, 14, '5075426581'),
	(17, 17, 3, '5548795563'),
	(18, 18, 8, '5785630201'),
	(19, 19, 13, '5569686236'),
	(20, 20, 8, '5074563287'),
	(21, 21, 10, '5698296876'),
	(22, 22, 9, '5682638985'),
	(23, 23, 12, '5792304599'),
	(24, 24, 12, '5876230656'),
	(25, 25, 12, '5763082568'),
	(26, 26, 10, '5076263929'),
	(27, 27, 15, '5665696306'),
	(28, 28, 7, '5262349563'),
	(29, 29, 2, '5632828179'),
	(30, 30, 1, '5027302030'),
	(31, 31, 4, '5463268723'),
	(32, 32, 5, '5216787821'),
	(33, 33, 6, '5290846653'),
	(34, 34, 15, '5289749934'),
	(35, 35, 9, '5290847246');


--
-- Data for Name: kisi; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.kisi (kisino, tckimlikno, kisiad, kisisoyad, kisitur) VALUES
	(1, '11548763225', 'Necip Fazıl', 'Kısakürek', 1),
	(2, '15485236052', 'Atilla', 'İlhan', 1),
	(3, '24587569558', 'Yunus', 'Emre', 1),
	(4, '24785488754', 'Şermin', 'Yaşar', 1),
	(5, '25234625152', 'Can', 'Yücel', 1),
	(6, '75849652415', 'Erdem', 'Beyazıt', 1),
	(7, '45815243022', 'Cahit', 'Zarifoğlu', 1),
	(8, '21520224856', 'Aylin', 'Genç', 1),
	(9, '27854521506', 'Mine', 'Akgün', 1),
	(10, '24859624751', 'Tuanna', 'Çelik', 1),
	(11, '15421187854', 'Fatma Nur', 'Aksu', 1),
	(12, '15456988956', 'Ezgi', 'Sarı', 1),
	(13, '78916872532', 'Cemal', 'Süreya', 1),
	(14, '16531338362', 'Tomris', 'Uyar', 1),
	(15, '25488525852', 'Rasim', ' Özdenören', 1),
	(16, '11254875421', 'Merve', 'Şentürk', 2),
	(17, '45248275413', 'Emirhan', 'Etli', 2),
	(18, '44587269863', 'Emre', 'Kara', 2),
	(19, '11547856325', 'Yasemin', 'Yalçınkaya', 2),
	(20, '15428965736', 'Semih', 'Kopcal', 2),
	(21, '24973405778', 'Esma', 'Yıldız', 2),
	(22, '11548787581', 'İlyas', 'Aydın', 2),
	(23, '15428596352', 'Harun', 'Genç', 2),
	(24, '11698857748', 'Mehmet Emir', 'Çağan', 2),
	(25, '25548692574', 'Erva', 'Çağan', 2),
	(26, '34525627653', 'Büşra', 'Yılmaz', 2),
	(27, '62378390123', 'Kübra', 'Kızıl', 2),
	(28, '24536588745', 'Murat', 'Gök', 2),
	(29, '15466285662', 'Adem', 'Dikbaş', 2),
	(30, '56423287653', 'Ebrar', 'Ayar', 2),
	(31, '31267863287', 'Berna', 'Ayan', 2),
	(32, '78163893253', 'Miray', 'Tiryaki', 2),
	(33, '25146387798', 'Yusuf', 'Demir', 2),
	(34, '12022686685', 'Deniz', 'Çiçek', 2),
	(35, '41198637658', 'Tarık', 'Buğra', 2),
	(36, '23456753625', 'ayşegül', 'gül', 2);


--
-- Data for Name: muhasebe; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.muhasebe (islemno, otelno, gelir, gider, kasadurum) VALUES
	(1, 1, '?54.000,00', '?123.631,00', '?56.378,00');


--
-- Data for Name: musteri; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.musteri (musterino, rezervasyonno) VALUES
	(7, 1),
	(1, 2),
	(3, 3);


--
-- Data for Name: oda; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.oda (odano, otelno, odakat, gunlukfiyat, kisisayisi, odatur, odaresim) VALUES
	(101, 1, 0, '?550,45', 3, 'familyroom', 1),
	(125, 1, 2, '?3.342,67', 6, 'kingsuiteroom', 15),
	(102, 1, 0, '?1.024,98', 2, 'doubleroom', 2),
	(103, 1, 0, '?556,45', 2, 'suiteroom', 3),
	(104, 1, 0, '?705,60', 1, 'handicappedroom', 4),
	(105, 1, 0, '?2.045,45', 6, 'kingsuiteroom', 5),
	(111, 1, 1, '?650,67', 4, 'familyroom', 6),
	(112, 1, 1, '?1.089,45', 2, 'doubleroom', 7),
	(113, 1, 1, '?677,45', 2, 'suiteroom', 8),
	(114, 1, 1, '?1.300,90', 4, 'quadroom', 9),
	(115, 1, 1, '?2.890,34', 6, 'kingsuiteroom', 10),
	(121, 1, 2, '?750,88', 5, 'familyroom', 11),
	(122, 1, 2, '?1.145,55', 2, 'doubleroom', 12),
	(123, 1, 2, '?770,45', 2, 'suiteroom', 13),
	(124, 1, 2, '?2.500,30', 8, 'dublexroom', 14);


--
-- Data for Name: odaResim; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public."odaResim" (odano, dosyayolu) VALUES
	(101, 'C:\Users\Monster\Desktop\Oda Resimleri\familyroom.png'),
	(102, 'C:\Users\Monster\Desktop\Oda Resimleri\doubleroom.png'),
	(103, 'C:\Users\Monster\Desktop\Oda Resimleri\suiteroom.png'),
	(104, 'C:\Users\Monster\Desktop\Oda Resimleri\handicappedroom.jpg'),
	(105, 'C:\Users\Monster\Desktop\Oda Resimleri\kingsuit.jpg'),
	(111, 'C:\Users\Monster\Desktop\Oda Resimleri\familyroom1.png'),
	(112, 'C:\Users\Monster\Desktop\Oda Resimleri\doubleroom1.png'),
	(113, 'C:\Users\Monster\Desktop\Oda Resimleri\suiteroom1.png'),
	(114, 'C:\Users\Monster\Desktop\Oda Resimleri\quadroom.jpg'),
	(115, 'C:\Users\Monster\Desktop\Oda Resimleri\kingsuit1.jpg'),
	(121, 'C:\Users\Monster\Desktop\Oda Resimleri\familyroom2.jpg'),
	(122, 'C:\Users\Monster\Desktop\Oda Resimleri\doubleroom2.jpg'),
	(123, 'C:\Users\Monster\Desktop\Oda Resimleri\suiteroom2.jpg'),
	(124, 'C:\Users\Monster\Desktop\Oda Resimleri\dublexroom.jpg'),
	(125, 'C:\Users\Monster\Desktop\Oda Resimleri\kingsuit2.jpg');


--
-- Data for Name: otel; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.otel (otelno, otelad, otelyildiz, oteltur, adresno) VALUES
	(1, 'postgre Otel', 5, 'termal otel', 6);


--
-- Data for Name: personel; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.personel (personelno, personeltipi) VALUES
	(16, 'yonetici'),
	(17, 'yonetici'),
	(18, 'yonetici'),
	(19, 'danisman'),
	(20, 'hizmetli'),
	(21, 'yonetici'),
	(22, 'yonetici'),
	(23, 'danisman'),
	(24, 'danisman'),
	(25, 'danisman'),
	(26, 'danisman'),
	(27, 'hizmetli'),
	(28, 'hizmetli'),
	(29, 'hizmetli'),
	(30, 'hizmetli'),
	(31, 'hizmetli'),
	(32, 'hizmetli'),
	(33, 'hizmetli'),
	(34, 'hizmetli'),
	(35, 'hizmetli'),
	(36, 'hizmetli');


--
-- Data for Name: personelResim; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public."personelResim" (personelno, dosyayolu) VALUES
	(16, 'C:\Users\Monster\Desktop\Oda Resimleri\woman2.jpeg'),
	(17, 'C:\Users\Monster\Desktop\Oda Resimleri\man.jpeg'),
	(18, 'C:\Users\Monster\Desktop\Oda Resimleri\man2.jpg'),
	(19, 'C:\Users\Monster\Desktop\Oda Resimleri\woman.jpeg'),
	(20, 'C:\Users\Monster\Desktop\Oda Resimleri\man3.jpeg'),
	(21, 'C:\Users\Monster\Desktop\Oda Resimleri\woman1.jpeg'),
	(22, 'C:\Users\Monster\Desktop\Oda Resimleri\man4.jpeg'),
	(23, 'C:\Users\Monster\Desktop\Oda Resimleri\man5.jpeg'),
	(24, 'C:\Users\Monster\Desktop\Oda Resimleri\man7.jpeg'),
	(25, 'C:\Users\Monster\Desktop\Oda Resimleri\woman3.jpeg'),
	(26, 'C:\Users\Monster\Desktop\Oda Resimleri\woman4.jpeg'),
	(27, 'C:\Users\Monster\Desktop\Oda Resimleri\woman5.jpeg'),
	(28, 'C:\Users\Monster\Desktop\Oda Resimleri\man6.jpeg'),
	(29, 'C:\Users\Monster\Desktop\Oda Resimleri\man8.jpeg'),
	(30, 'C:\Users\Monster\Desktop\Oda Resimleri\woman6.jpeg'),
	(31, 'C:\Users\Monster\Desktop\Oda Resimleri\woman7.jpeg'),
	(32, 'C:\Users\Monster\Desktop\Oda Resimleri\woman8.jpeg'),
	(33, 'C:\Users\Monster\Desktop\Oda Resimleri\man9.jpeg'),
	(34, 'C:\Users\Monster\Desktop\Oda Resimleri\woman10.jpeg'),
	(35, 'C:\Users\Monster\Desktop\Oda Resimleri\man10.jpeg');


--
-- Data for Name: rezervasyon; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.rezervasyon (rezervasyonno, otelno, odano, kayitno, musterino, ucret) VALUES
	(1, 1, 101, 1, 7, NULL),
	(2, 1, 102, 2, 1, NULL),
	(3, 1, 101, 3, 3, NULL);


--
-- Data for Name: takvim; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.takvim (kayitno, giristarihi, cikistarihi, doluluk, dolusure) VALUES
	(3, '2023-01-03', '2023-01-04', B'1', 1),
	(2, '2023-01-03', '2023-01-05', B'1', 2),
	(1, '2023-01-07', '2023-01-09', B'1', 2);


--
-- Data for Name: yonetici; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.yonetici (yoneticino, otelno, yoneticitur, yoneticimaas, kullaniciadi, sifre) VALUES
	(16, 1, 'Muhasebe Müdürü', 8765.00, 'mervesenturk', 'merve123'),
	(17, 1, 'Müşteri İlişkileri Müdürü', 9954.00, 'emirhanetli', 'emirhan123'),
	(18, 1, 'Güvenlik Müdürü', 7893.00, 'emrekara', 'emre123'),
	(21, 1, 'Personel Müdürü', 10524.00, 'esmayildiz', 'esma123'),
	(22, 1, 'Ön Büro Müdürü', 9845.00, 'ilyasaydın', 'ilyas123');


--
-- Name: adres_adresno_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.adres_adresno_seq', 1, false);


--
-- Name: adres_ilceno_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.adres_ilceno_seq', 1, false);


--
-- Name: adres_ilno_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.adres_ilno_seq', 1, false);


--
-- Name: danisman_danismanno_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.danisman_danismanno_seq', 1, false);


--
-- Name: danisman_otelno_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.danisman_otelno_seq', 1, false);


--
-- Name: hizmetli_hizmetlino_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.hizmetli_hizmetlino_seq', 1, true);


--
-- Name: hizmetli_otelno_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.hizmetli_otelno_seq', 1, false);


--
-- Name: il_ilno_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.il_ilno_seq', 1, false);


--
-- Name: ilce_ilceno_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.ilce_ilceno_seq', 1, false);


--
-- Name: iletisimBilgileri_iletisimno_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."iletisimBilgileri_iletisimno_seq"', 1, false);


--
-- Name: iletisimBilgileri_kisino_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."iletisimBilgileri_kisino_seq"', 1, false);


--
-- Name: kisi_kisino_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.kisi_kisino_seq', 1, false);


--
-- Name: muhasebe_islemno_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.muhasebe_islemno_seq', 1, false);


--
-- Name: muhasebe_otelno_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.muhasebe_otelno_seq', 1, false);


--
-- Name: musteri_musterino_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.musteri_musterino_seq', 1, false);


--
-- Name: musteri_rezervasyonno_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.musteri_rezervasyonno_seq', 1, false);


--
-- Name: odaResim_odano_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."odaResim_odano_seq"', 1, false);


--
-- Name: oda_odano_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.oda_odano_seq', 1, false);


--
-- Name: oda_otelno_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.oda_otelno_seq', 1, false);


--
-- Name: otel_adresno_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.otel_adresno_seq', 1, false);


--
-- Name: otel_otelno_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.otel_otelno_seq', 1, false);


--
-- Name: personelResim_personelno_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."personelResim_personelno_seq"', 1, false);


--
-- Name: personel_personelno_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.personel_personelno_seq', 1, false);


--
-- Name: rezervasyon_kayitno_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.rezervasyon_kayitno_seq', 1, false);


--
-- Name: rezervasyon_musterino_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.rezervasyon_musterino_seq', 1, false);


--
-- Name: rezervasyon_odano_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.rezervasyon_odano_seq', 1, false);


--
-- Name: rezervasyon_otelno_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.rezervasyon_otelno_seq', 1, false);


--
-- Name: rezervasyon_rezervasyonno_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.rezervasyon_rezervasyonno_seq', 1, false);


--
-- Name: seqadresno; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.seqadresno', 16, false);


--
-- Name: seqilceno; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.seqilceno', 16, false);


--
-- Name: seqiletisimno; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.seqiletisimno', 36, false);


--
-- Name: seqilno; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.seqilno', 11, false);


--
-- Name: seqislemno; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.seqislemno', 1, false);


--
-- Name: seqkayitno; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.seqkayitno', 4, false);


--
-- Name: seqkisino; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.seqkisino', 38, true);


--
-- Name: seqrezervasyonno; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.seqrezervasyonno', 4, false);


--
-- Name: takvim_kayitno_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.takvim_kayitno_seq', 1, false);


--
-- Name: yonetici_otelno_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.yonetici_otelno_seq', 1, false);


--
-- Name: yonetici_yoneticino_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.yonetici_yoneticino_seq', 1, false);


--
-- Name: adres adres_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.adres
    ADD CONSTRAINT adres_pkey PRIMARY KEY (adresno);


--
-- Name: danisman danisman_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.danisman
    ADD CONSTRAINT danisman_pkey PRIMARY KEY (danismanno);


--
-- Name: hizmetli hizmetli_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.hizmetli
    ADD CONSTRAINT hizmetli_pkey PRIMARY KEY (hizmetlino);


--
-- Name: il il_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.il
    ADD CONSTRAINT il_pkey PRIMARY KEY (ilno);


--
-- Name: ilce ilce_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ilce
    ADD CONSTRAINT ilce_pkey PRIMARY KEY (ilceno);


--
-- Name: iletisimBilgileri iletisimBilgileri_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."iletisimBilgileri"
    ADD CONSTRAINT "iletisimBilgileri_pkey" PRIMARY KEY (iletisimno);


--
-- Name: iletisimBilgileri iletisimBilgileri_telefon_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."iletisimBilgileri"
    ADD CONSTRAINT "iletisimBilgileri_telefon_key" UNIQUE (telefon);


--
-- Name: kisi kisi_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.kisi
    ADD CONSTRAINT kisi_pkey PRIMARY KEY (kisino);


--
-- Name: kisi kisi_tckimlikno_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.kisi
    ADD CONSTRAINT kisi_tckimlikno_key UNIQUE (tckimlikno);


--
-- Name: muhasebe muhasebe_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.muhasebe
    ADD CONSTRAINT muhasebe_pkey PRIMARY KEY (islemno);


--
-- Name: musteri musteri_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.musteri
    ADD CONSTRAINT musteri_pkey PRIMARY KEY (musterino);


--
-- Name: odaResim odaResim_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."odaResim"
    ADD CONSTRAINT "odaResim_pkey" PRIMARY KEY (odano);


--
-- Name: oda oda_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.oda
    ADD CONSTRAINT oda_pkey PRIMARY KEY (odano);


--
-- Name: otel otel_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.otel
    ADD CONSTRAINT otel_pkey PRIMARY KEY (otelno);


--
-- Name: personelResim personelResim_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."personelResim"
    ADD CONSTRAINT "personelResim_pkey" PRIMARY KEY (personelno);


--
-- Name: personel personel_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.personel
    ADD CONSTRAINT personel_pkey PRIMARY KEY (personelno);


--
-- Name: rezervasyon rezervasyon_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.rezervasyon
    ADD CONSTRAINT rezervasyon_pkey PRIMARY KEY (rezervasyonno);


--
-- Name: takvim takvim_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.takvim
    ADD CONSTRAINT takvim_pkey PRIMARY KEY (kayitno);


--
-- Name: yonetici yonetici_kullaniciadi_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.yonetici
    ADD CONSTRAINT yonetici_kullaniciadi_key UNIQUE (kullaniciadi);


--
-- Name: yonetici yonetici_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.yonetici
    ADD CONSTRAINT yonetici_pkey PRIMARY KEY (yoneticino);


--
-- Name: takvim testgecesayisihesapla; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER testgecesayisihesapla AFTER INSERT ON public.takvim FOR EACH ROW EXECUTE FUNCTION public.gecesayisihesapla();


--
-- Name: muhasebe testgelirekle; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER testgelirekle AFTER INSERT ON public.muhasebe FOR EACH ROW EXECUTE FUNCTION public.gelirekle();


--
-- Name: muhasebe testgiderekle; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER testgiderekle AFTER INSERT ON public.muhasebe FOR EACH ROW EXECUTE FUNCTION public.giderekle();


--
-- Name: iletisimBilgileri adresiletisim_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."iletisimBilgileri"
    ADD CONSTRAINT adresiletisim_fk FOREIGN KEY (adresno) REFERENCES public.adres(adresno) MATCH FULL ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: otel adresotel_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.otel
    ADD CONSTRAINT adresotel_fk FOREIGN KEY (adresno) REFERENCES public.adres(adresno) MATCH FULL ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: adres iladres_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.adres
    ADD CONSTRAINT iladres_fk FOREIGN KEY (ilno) REFERENCES public.il(ilno) MATCH FULL ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: adres ilceadres_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.adres
    ADD CONSTRAINT ilceadres_fk FOREIGN KEY (ilceno) REFERENCES public.ilce(ilceno) MATCH FULL ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: iletisimBilgileri kisiiletisim_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."iletisimBilgileri"
    ADD CONSTRAINT kisiiletisim_fk FOREIGN KEY (kisino) REFERENCES public.kisi(kisino) MATCH FULL ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: musteri kisimusteri_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.musteri
    ADD CONSTRAINT kisimusteri_fk FOREIGN KEY (musterino) REFERENCES public.kisi(kisino) MATCH FULL ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: personel kisipersonel_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.personel
    ADD CONSTRAINT kisipersonel_fk FOREIGN KEY (personelno) REFERENCES public.kisi(kisino) MATCH FULL ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: odaResim odaresim_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."odaResim"
    ADD CONSTRAINT odaresim_fk FOREIGN KEY (odano) REFERENCES public.oda(odano) MATCH FULL ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: danisman oteldanisman_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.danisman
    ADD CONSTRAINT oteldanisman_fk FOREIGN KEY (otelno) REFERENCES public.otel(otelno) MATCH FULL ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: hizmetli otelhizmetli_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.hizmetli
    ADD CONSTRAINT otelhizmetli_fk FOREIGN KEY (otelno) REFERENCES public.otel(otelno) MATCH FULL ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: muhasebe otelmuhasebe_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.muhasebe
    ADD CONSTRAINT otelmuhasebe_fk FOREIGN KEY (otelno) REFERENCES public.otel(otelno) MATCH FULL ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: oda oteloda_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.oda
    ADD CONSTRAINT oteloda_fk FOREIGN KEY (otelno) REFERENCES public.otel(otelno) MATCH FULL ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: rezervasyon otelrezervasyon_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.rezervasyon
    ADD CONSTRAINT otelrezervasyon_fk FOREIGN KEY (otelno) REFERENCES public.otel(otelno) MATCH FULL ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: yonetici otelyonetici_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.yonetici
    ADD CONSTRAINT otelyonetici_fk FOREIGN KEY (otelno) REFERENCES public.otel(otelno) MATCH FULL ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: danisman personeldanisman_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.danisman
    ADD CONSTRAINT personeldanisman_fk FOREIGN KEY (danismanno) REFERENCES public.personel(personelno) MATCH FULL ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: hizmetli personelhizmetli_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.hizmetli
    ADD CONSTRAINT personelhizmetli_fk FOREIGN KEY (hizmetlino) REFERENCES public.personel(personelno) MATCH FULL ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: personelResim personelresim_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."personelResim"
    ADD CONSTRAINT personelresim_fk FOREIGN KEY (personelno) REFERENCES public.personel(personelno) MATCH FULL ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: yonetici personelyonetici_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.yonetici
    ADD CONSTRAINT personelyonetici_fk FOREIGN KEY (yoneticino) REFERENCES public.personel(personelno) MATCH FULL ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: rezervasyon rezervasyonkayit_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.rezervasyon
    ADD CONSTRAINT rezervasyonkayit_fk FOREIGN KEY (kayitno) REFERENCES public.takvim(kayitno) MATCH FULL ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: musteri rezervasyonmusteri_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.musteri
    ADD CONSTRAINT rezervasyonmusteri_fk FOREIGN KEY (rezervasyonno) REFERENCES public.rezervasyon(rezervasyonno) MATCH FULL ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: rezervasyon rezervasyonoda_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.rezervasyon
    ADD CONSTRAINT rezervasyonoda_fk FOREIGN KEY (odano) REFERENCES public.oda(odano) MATCH FULL ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE USAGE ON SCHEMA public FROM PUBLIC;
GRANT ALL ON SCHEMA public TO PUBLIC;


--
-- PostgreSQL database dump complete
--

