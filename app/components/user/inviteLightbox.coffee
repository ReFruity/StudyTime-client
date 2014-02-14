React = require 'react'
{span, div, ul, li, input, nav, a, i, h2, h3, p, label, button} = React.DOM
{i18n, authorized, currentUserMixin, taggedInput} = require '/components/common', 'authorized', 'currentUserMixin', 'taggedInput'
{classSet} = React.addons

module.exports = React.createClass
  propTypes:
    onClose: React.PropTypes.func.isRequired
    withContinue: React.PropTypes.boolean

  onClose: ->
    @props.onClose()

  getInitialState: ->
    inviteLink: 'http://studytime.me/invite/123'
    emails: []
    emailSendingStatus: 0

  componentDidMount: ->
    link = @refs.inviteLink.getDOMNode()
    setTimeout(->
      link.focus()
      link.select()
    , 150)

  setEmailsList: (emails)->
    @setState emails: emails

  sendEmailInvites: ->
    _gaq.push(['_trackEvent', 'Invite Lightbox', 'Email', JSON.stringify(@state.emails)])
    @setState emailSendingStatus: 1

  openVkPopup: ->
    _gaq.push(['_trackEvent', 'Invite Lightbox', 'VKontakte'])
    window.open("http://vkontakte.ru/share.php?url=#{@state.inviteLink}", 'Vk Share', 'height=400,width=600')
  openFbPopup: ->
    _gaq.push(['_trackEvent', 'Invite Lightbox', 'Facebook'])
    window.open("http://facebook.com/share.php?u=#{@state.inviteLink}", 'Facebook Share', 'height=400,width=600')
  openTwPopup: ->
    _gaq.push(['_trackEvent', 'Invite Lightbox', 'Twitter'])
    window.open("http://twitter.com/share?url=#{@state.inviteLink}", 'Twitter Share', 'height=400,width=600')

  render: ->
    div {className: 'invite-lightbox'},
      div {className: 'container'},
        div {className: 'row'},
          div {className: 'col-sm-12 form-group link'},
            label {htmlFor:'inviteLinkInput'}, 'Ссылка для приглашения'
            input {id: 'inviteLinkInput', ref: 'inviteLink', className: 'form-control', value: @state.inviteLink}
        div {className: 'row variants'},
          div {className: 'or'}, ''
          div {className: 'col-sm-6 email'},
            h3 {}, 'Отправить по EMail'
            div {className: 'form-group'},
              taggedInput {id: 'inviteEmails', onChange: @setEmailsList, value: @state.emails, className: 'form-control', placeholder: 'EMail адреса администрации'}
            div {className: ''},
              switch @state.emailSendingStatus
                when 0 then button {className: 'btn btn-success', onClick: @sendEmailInvites}, 'Отправить приглашение'
                when 1 then span {className: 'sending'}, 'Отправляю...'
                when 2 then span {className: 'sent'}, 'Приглашения отправлены'

          div {className: 'col-sm-6 social'},
            h3 {}, 'Поделиться в социальных сетях'
            div {className: 'buttons'},
              a {className: 'vk', onClick: @openVkPopup},
                i {className: 'stico-vk'}
              a {className: 'fb', onClick: @openFbPopup},
                i {className: 'stico-fb'}
              a {className: 'tw', onClick: @openTwPopup},
                i {className: 'stico-twitter'}
          div {className: 'clearfix'}
