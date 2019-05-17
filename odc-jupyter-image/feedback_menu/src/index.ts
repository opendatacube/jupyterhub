import {
  JupyterLab, JupyterLabPlugin
} from '@jupyterlab/application';

import {IMainMenu} from '@jupyterlab/mainmenu'

import {IFrame, ICommandPalette} from '@jupyterlab/apputils'

import {Menu} from '@phosphor/widgets'

import '../style/index.css';


/**
 * Initialization data for the feedback_menu extension.
 */
const extension: JupyterLabPlugin<void> = {
  id: 'feedback_menu',
  autoStart: true,
  requires: [IMainMenu, ICommandPalette],
  activate: activate_custom_menu
};

export default extension;

export const BookMarks = [
  {
      name: 'Click to Provide Feedback',
      url: 'https://forms.gle/roRmS3WU2Uj7gsg56',
      description: 'Creating a simple JupyterLab plugin adding BookMark menu',
      target: 'widget'
  }
];

export function activate_custom_menu(app: JupyterLab, mainMenu: IMainMenu, palette:
  ICommandPalette): Promise<void>{

  // create new commands and add them to app.commands

  function appendNewCommand(item: any) {
      let iframe: IFrame = null;
      let command = `Feedback-${item.name}:show`;
      app.commands.addCommand(command, {

          label: item.name,
          execute: () => {
              if (item.target == '_blank') {
                  let win = window.open(item.url, '_blank');
                  win.focus();
              } else if (item.target == 'widget') {
                  if (!iframe) {
                      iframe = new IFrame();
                      iframe.url = item.url;
                      iframe.id = item.name;
                      iframe.title.label = item.name;
                      iframe.title.closable = true;
                      iframe.node.style.overflowY = 'auto';
                  }

                  if (iframe == null || !iframe.isAttached) {
                      app.shell.addToMainArea(iframe);
                      app.shell.activateById(iframe.id);
                  } else {
                      app.shell.activateById(iframe.id);
                  }
              }
          }
      });
  }

  BookMarks.forEach(item => appendNewCommand(item));

  // add to mainMenu
  let menu = Private.createMenu(app);
  mainMenu.addMenu(menu, {rank: 80});
  return Promise.resolve(void 0);
}

/**
* A namespace for help plugin private functions.
*/

namespace Private {

  /**
   * Creates a menu for the help plugin.
   */
  export function createMenu(app: JupyterLab): Menu {

      const {commands} = app;
      let menu:Menu = new Menu({commands});
      menu.title.label = 'Feedback';
      BookMarks.forEach(item => menu.addItem({command: `Feedback-${item.name}:show`}));

      return menu;
  }
}