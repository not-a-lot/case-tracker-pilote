xquery version "3.0";
(: --------------------------------------
   Case tracker pilote application

   Creator: Stéphane Sire <s.sire@oppidoc.fr>

   Generates extension points for Demo formular

   FIXME:
   - replace form:gen-coach-selector by person:gen-person-selector when goal is to search ?
   - generate (and localize) sex, civility and function fields from DB content ?

   September 2013 - (c) Copyright 2013 Oppidoc SARL. All Rights Reserved.
   ----------------------------------------------- :)

declare default element namespace "http://www.w3.org/1999/xhtml";

import module namespace oppidum = "http://oppidoc.com/oppidum/util" at "../../../oppidum/lib/util.xqm";
import module namespace form = "http://oppidoc.com/ns/xcm/form" at "../../../xcm/lib/form.xqm";
import module namespace custom = "http://oppidoc.com/ns/xcm/custom" at "../../app/custom.xqm";

declare namespace xt = "http://ns.inria.org/xtiger";
declare namespace site = "http://oppidoc.com/oppidum/site";

declare option exist:serialize "method=xml media-type=text/xml";

let $cmd := request:get-attribute('oppidum.command')
let $lang := string($cmd/@lang)
let $target := oppidum:get-resource(oppidum:get-command())/@name
let $goal := request:get-parameter('goal', 'read')

(: Important : We declare a default namespace here, with « declare default element namespace "http://www.w3.org/1999/xhtml"; ». A default ns applies to every segment of an XPath expression ! Therefore, an expression such as « $animals/Item/text() » does not work, because eXist looks for « $animals/xhtml:Item/text() », which it does not find. There are several ways of solving this problem, but in simple cases like in this file, the shortest way is to add appropriate filters : « *[local-name(.) eq 'Animals'] » and « *[local-name(.) eq 'Item'] ». :)

return
  if ($goal = ('update','create')) then
    let $animals := doc('/db/sites/ctracker/ajax-tests/animals.xml')/*[local-name(.) eq 'Animals']

    let $ids := data($animals/*[local-name(.) eq 'Item']/@value)
    let $labels := $animals/*[local-name(.) eq 'Item']/text() ! fn:replace(., '\s', '\\ ')
      return
        <site:view>
          <site:field Key="company">
            <xt:use types="choice" i18n="Apple IBM Microsoft" values="1 2 3"
            param="filter=event optional;class=span12 a-control"
            ></xt:use>
          </site:field>
          <site:field Key="contact">
            <xt:use types="choice"
            param="filter=event optional;class=span12 a-control"
            ></xt:use>
          </site:field>
          <site:field Key="contract">
            <xt:use types="choice"
            param="filter=optional;class=span12 a-control"
            ></xt:use>
          </site:field>
          <site:select2 Key="animals">
            <xt:use types="select2" values="{fn:string-join($ids, ' ')}" i18n="{fn:string-join($labels, ' ')}"/>
          </site:select2>
        </site:view>
  else (: 'read' - only constant fields  :)
    <site:view/>
