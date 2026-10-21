module EventRegistrationsHelper
  STATUS_TAG_VARIANTS = {
    "registered" => "tag--primary",
    "attended" => "tag--success",
    "no_show" => "tag--danger"
  }.freeze

  def registration_status_tag(registration)
    tag.span registration.status.titleize, class: [ "tag", STATUS_TAG_VARIANTS[registration.status] ]
  end
end
