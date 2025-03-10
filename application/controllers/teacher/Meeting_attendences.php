<?php defined('BASEPATH') OR exit('No direct script access allowed');

/**
 * CMS Sekolahku Premium Version
 * @version    2.5.4
 * @author     Anton Sofyan | https://facebook.com/antonsofyan | 4ntonsofyan@gmail.com | 0857 5988 8922
 * @copyright  (c) 2017-2023
 * @link       https://sekolahku.web.id
 *
 * PERINGATAN :
 * 1. TIDAK DIPERKENANKAN MENGGUNAKAN CMS INI TANPA SEIZIN DARI PIHAK PENGEMBANG APLIKASI.
 * 2. TIDAK DIPERKENANKAN MEMPERJUALBELIKAN APLIKASI INI TANPA SEIZIN DARI PIHAK PENGEMBANG APLIKASI.
 * 3. TIDAK DIPERKENANKAN MENGHAPUS KODE SUMBER APLIKASI.
 */

class Meeting_attendences extends Admin_Controller {

	/**
	 * Class Constructor
	 *
	 * @return Void
	 */
	public function __construct() {
		parent::__construct();
		$this->load->model([
			'm_class_meetings',
			'm_meeting_attendences'
		]);
		// Jika bukan Guru, redirect ke dashboard
		$employment_type = __session('employment_type');
		if (NULL !== $employment_type && FALSE === strpos(strtolower($employment_type), 'guru')) {
			return redirect('dashboard', 'refresh');
		}
	}

	/**
	 * Update Meeting Attendences
	 * @return Object
	 */
	public function update() {
		if ($this->input->is_ajax_request()) {
			$meeting_attendences = json_decode($this->input->post('meeting_attendences'), true);
			$query = $this->m_meeting_attendences->update($meeting_attendences);
			$this->vars['status'] = $query > 0 ? 'success' : 'error';
			$this->output
				->set_content_type('application/json', 'utf-8')
				->set_output(json_encode($this->vars, self::REQUIRED_FLAGS))
				->_display();
			exit;
		}
	}

	/**
	 * Get Meeting Attendences
	 */
	public function get_meeting_attendences() {
		if ($this->input->is_ajax_request()) {
			$this->vars['meeting_attendences'] = [];
			$course_class_id = _toInteger($this->input->post('course_class_id', true));
			$date = $this->input->post('date', true);
			if ( _isNaturalNumber( $course_class_id ) && _isValidDate($date)) {
				// Get Class Meeting ID
				$class_meeting_id = $this->m_class_meetings->class_meeting_id($course_class_id, $date);
				// Get Course Class
				$query = $this->model->RowObject('id', $course_class_id, 'course_classes');
				// Generate if not exist Attendance
				$this->m_meeting_attendences->insert($class_meeting_id, $query->academic_year_id, $query->class_group_id);
				if ($class_meeting_id && $class_meeting_id > 0 && ctype_digit((string) $class_meeting_id)) {
					$this->vars['status'] = 'success';
					$this->vars['meeting_attendences'] = $this->m_meeting_attendences->get_meeting_attendences($class_meeting_id);
				}
			}

			$this->output
				->set_content_type('application/json', 'utf-8')
				->set_output(json_encode($this->vars, self::REQUIRED_FLAGS))
				->_display();
			exit;
		}
	}
}
