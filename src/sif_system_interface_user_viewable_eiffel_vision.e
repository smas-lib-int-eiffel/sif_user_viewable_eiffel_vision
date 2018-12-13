note
	description: "Summary description for {SIF_SYSTEM_INTERFACE_USER_VIEWABLE_EIFFEL_VISION}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SIF_SYSTEM_INTERFACE_USER_VIEWABLE_EIFFEL_VISION
	inherit
		SIF_SYSTEM_INTERFACE_USER_VIEWABLE
		redefine
			make,
			error,
			activate_view,
			destroy
		end

		EV_SHARED_APPLICATION

		EV_DIALOG_CONSTANTS

create
	make

feature -- Initialization

	make
		do
			Precursor
			create error_dialog
		end

feature -- Identification

	id : INTEGER
			-- Return the correct system interface identifier as defined in SIF_SYSTEM_INTERFACE_IDENTIFIERS
		do
			Result := Sii_user_viewable_eiffel_vision
		end

feature -- Access

	activate_view( a_view_identifier : INTEGER_64)
		-- To be able to present modal error dialogs, it neccesary to know which view is the last activated view
		-- for now it's assumed that the last activated view is always usable to be used as parent window to which
		-- other dialogs can be viewed in a modal fashion.
		do
			Precursor(a_view_identifier)
			if attached views.found_item as l_view_to_activate then
				last_activated_view := l_view_to_activate
			end
		end

	destroy
		do
			Precursor
			if attached {EV_APPLICATION} ev_application as l_app then
				l_app.destroy
			end
		end

feature -- Error handling

	error (an_error: STRING)
			-- an error ocurred, make sure the external user or system is notified
		do
			create error_dialog
			error_dialog.set_text (an_error)
			error_dialog.set_buttons (<<ev_ok>>)
			error_dialog.set_default_push_button (error_dialog.button (ev_ok))
			error_dialog.set_width (error_dialog.width + 30)
			error_dialog.set_height (error_dialog.height + 10)
			if attached {EV_WINDOW}last_activated_view as l_last_activated_view then
				error_dialog.show_modal_to_window (l_last_activated_view)
			end
		end

feature {NONE} -- Implementation

	error_dialog : EV_ERROR_DIALOG

	last_activated_view: detachable SIF_VIEW

end
