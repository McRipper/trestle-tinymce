/* global Trestle, tinymce */

export default class extends Trestle.ApplicationController {
  static values = {
    configuration: {
      type: String,
      default: 'default'
    }
  }

  connect () {
    const { setup, ...configuration } = this.configuration || {}
    const initialization = {}
    const controller = this

    this.initialization = initialization
    this.element.ownerDocument.addEventListener('turbo:before-cache', this.removeEditor)

    tinymce.init({
      target: this.element,
      ...configuration,
      setup (editor) {
        if (controller.initialization !== initialization) {
          // TinyMCE may construct the editor after the controller has disconnected.
          queueMicrotask(() => editor.remove())
          return
        }

        initialization.editor = editor
        if (typeof setup === 'function') setup.call(this, editor)
      }
    })
  }

  disconnect () {
    this.element.ownerDocument.removeEventListener('turbo:before-cache', this.removeEditor)
    this.removeEditor()
  }

  removeEditor = () => {
    const editor = this.initialization?.editor
    this.initialization = undefined
    editor?.remove()
  }

  get configuration () {
    return Trestle.TinyMCE[this.configurationValue]
  }
}
