xquery version "3.0";
declare namespace site = "http://oppidoc.com/oppidum/site";
declare namespace xt = "http://ns.inria.org/xtiger";

let $animals := doc('/db/sites/ctracker/ajax-tests/animals.xml')/Animals
let $ids := data($animals/Item/@value)
let $labels := $animals/Item/text()

return
  <site:view>
    <site:select2 Key="animals">
      <xt:use types="select2" values="{fn:string-join($ids, ' ')}" i18n="{fn:string-join($labels, ' ')}"/>
    </site:select2>
  </site:view>