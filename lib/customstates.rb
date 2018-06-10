# -*- encoding : utf-8 -*-
# See `http://alaveteli.org/docs/customising/themes/#customising-the-request-states`
# for more explanation of this file

module InfoRequestCustomStates

	def self.included(base)
		base.extend(ClassMethods)
	end

  # Work out what the situation of the request is. In addition to
  # values of self.described_state, in base Alaveteli can return
  # these (calculated) values:
  #   waiting_classification
  #   waiting_response_overdue
  #   waiting_response_very_overdue
    def theme_calculate_status
		return 'waiting_classification' if awaiting_description
        return described_state unless waiting_response?
        return 'waiting_response_very_overdue' if
            Time.now.strftime("%Y-%m-%d") > date_very_overdue_after.strftime("%Y-%m-%d")
        return 'waiting_response_overdue' if
            Time.now.strftime("%Y-%m-%d") > date_response_required_by.strftime("%Y-%m-%d")
        return 'deadline_extended' if has_extended_deadline?
        return 'waiting_response'
    end

  # Mixin methods for InfoRequest
  module ClassMethods

    # Return the name of a custom status.
    # Example of how to add a custom status:
    # def theme_display_status(status)
    #     if status == 'transferred'
    #         _("Transferred.")
    #     else
    #         raise _("unknown status ") + status
    #     end
    # end
		def theme_display_status(status)
            if status == 'deadline_extended'
                _("Deadline extended.")
            else
                raise _("unknown status ") + status
            end
        end

    # Return the list of custom statuses added by the theme.
    # Example of how to add a custom status:
    # def theme_extra_states
    #     return ['transferred']
    # end
		def theme_extra_states
            return ['deadline_extended']
        end
	end
end

module RequestControllerCustomStates

  # `theme_describe_state` is called after the core describe_state code.
  # It should end by raising an error if the status is unknown.
  # Example of how to add a custom status:
  # def theme_describe_state(info_request)
  #   if info_request.calculate_status == 'transferred'
  #     flash[:notice] = _("Authority has transferred your request to a different public body.")
  #       redirect_to request_url(@info_request)
  #   else
  #     raise "unknown calculate_status " + info_request.calculate_status
  #   end
  # end
	def theme_describe_state(info_request)
        # called after the core describe_state code.  It should
        # end by raising an error if the status is unknown
        if info_request.calculate_status == 'deadline_extended'
            flash[:notice] = _("<p>Thank you! Hopefully your wait isn't too long.</p> <p>By law, you should get a response promptly, and normally before the end of <strong>
            {{date_response_required_by}}</strong>.</p>",
              :date_response_required_by => view_context.simple_date(info_request.date_response_required_by))
            redirect_to request_url(info_request)
        else
            raise "unknown calculate_status " + info_request.calculate_status
        end
    end

end
