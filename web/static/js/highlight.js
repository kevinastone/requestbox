
import Prism from 'prismjs';
import _PrismHTTP from 'prismjs/components/prism-http';
import _PrismJSON from 'prismjs/components/prism-json';

function selector(lang) {
  return `code.language-${lang}, .language-${lang} > code, code.lang-${lang}, .lang-${lang} > code`;
}

function prettyJSON() {
  for (const element of Array.from(document.querySelectorAll(selector('json')))) {
    try {
      element.innerText = JSON.stringify(JSON.parse(element.innerText), null, 2);
    } catch (error) {
      // do nothing
    }
  }
}

export default () => {
  prettyJSON();
  Prism.highlightAll();
};
