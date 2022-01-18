# PagerBot

A fork of https://github.com/goodeggs/pagerbot, which is a fork of
https://github.com/YoSmudge/pagerbot.

Update your Slack user groups based on your PagerDuty Schedules.

PagerBot is a simple program to do this. Provided with your PagerDuty
and Slack API credentials, and some simple configuration, it will update
the usergroups automatically, as well as posting a message to channels
you select informing everyone who's currently on the rotation.

# Installation

`go build`

# Configuration

A basic configuration file will look like

```yaml
api_keys:
  slack: "abcd123"
  pagerduty:
    org: "songkick"
    key: "qwerty567"

groups:
  - name: firefighter
    schedules:
      - PAAAAAA
      - PBBBBBB
    update_message:
      message: ":fire_engine: Your firefighters are %s :fire_engine:"
      channels:
        - general
  - name: fielder
    schedules:
      - PCCCCCC
    update_message:
      message: "Your :baseball: TechOps @Fielder :baseball: this week is %s"
      channels:
        - team-engineering
```

The configuration should be fairly straightforward, under API keys
provide your Slack and Pagerduty keys. Under groups configure the Slack
groups you'd like to update. `schedules` is a list of PagerDuty schedule
IDs, `update_message` is the message you'd like to post, and the channels
you'd like to post them in.

Once done, you can run PagerBot with `./pagerbot --config /path/to/config.yml`

It's recommended to run PagerBot under Upstart or some other process manager.

N.B. PagerBot matches PagerDuty users to Slack users by their email
addresses, so your users must have the same email address in Slack as in
PagerDuty. PagerBot will log warnings for any users it finds in
PagerDuty but not in Slack.
