package slack

import (
	"github.com/slack-go/slack"
)

func (a *Api) PostMessage(channel string, message string) error {
	mp := slack.NewPostMessageParameters()
	mp.Username = "pagerbot"
	mp.AsUser = true
	mp.LinkNames = 1

	_, _, err := a.api.PostMessage(
		channel,
		slack.MsgOptionText(message, false),
		slack.MsgOptionPostMessageParameters(mp),
	)
	return err
}
