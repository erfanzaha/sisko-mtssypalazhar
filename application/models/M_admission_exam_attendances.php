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

class M_admission_exam_attendances extends CI_Model {

	/**
	 * Primary key
	 * @var String
	 */
	public static $pk = 'id';

	/**
	 * Table
	 * @var String
	 */
	public static $table = 'admission_exam_attendances';

	/**
	 * Get attendance lists
	 * @param Integer $exam_schedule_id
	 * @return Resource
	 */
	public function get_attendance_lists($exam_schedule_id) {
		$this->db->select('x1.id, x2.registration_number, x2.full_name, x1.presence');
		$this->db->join('users x2', 'x1.student_id = x2.id', 'LEFT');
		$this->db->where('x1.exam_schedule_id', _toInteger($exam_schedule_id));
		$this->db->where('x2.re_registration', 'true');
		$this->db->where('x1.is_deleted', 'false');
		$this->db->where('x2.is_deleted', 'false');
		$this->db->order_by('x2.registration_number', 'ASC');
		return $this->db->get(self::$table . ' x1');
	}

	/**
	 * Save Attendances List
	 * @param Array $ids
	 * @param Integer $exam_schedule_id
	 * @return Boolean
	 */
	public function save_attendance_lists($ids, $exam_schedule_id) {
		$counter = 0;
		foreach ($ids as $id) {
			$this->db->set('student_id', _toInteger($id));
			$this->db->set('exam_schedule_id', _toInteger($exam_schedule_id));
			$this->db->set('created_by', (int) __session('user_id'));
			$query = $this->db->insert(self::$table);
			if ( $query ) $counter++;
		}
		return _isNaturalNumber( $counter );
	}

	/**
	 * Delete Attendances List
	 * @param Array $ids
	 * @return Boolean
	 */
	public function delete_attendance_lists($ids) {
		return $this->db
			->where_in('id', $ids)
			->delete(self::$table);
	}

	/**
	 * Save Presences
	 * @param Array $presences
	 * @return Boolean
	 */
	public function save_attendance($presences) {
		$count = 0;
		foreach ($presences as $row) {
			$this->db->set('updated_by', (int) __session('user_id'));
			$this->db->set('presence', $row['presence']);
			$this->db->where('id', _toInteger($row['id']));
			$query = $this->db->update(self::$table);
			if ($query) $count++;
		}
		return _isNaturalNumber( $count );
	}

	/**
	 * Get Prospective Students
	 * @param Integer $subject_setting_detail_id
	 * @return Resource
	 */
	public function get_prospective_students($subject_setting_detail_id) {
		// Get Exam Schedule Ids
		$exam_schedule_ids = $this->db
			->select('id')
			->from('admission_exam_schedules')
			->where('subject_setting_detail_id', _toInteger($subject_setting_detail_id))
			->where('is_deleted', 'false')
			->get_compiled_select();
		// Get Student Ids
		$student_ids = $this->db
				->select('student_id')
				->from(self::$table)
				->where('exam_schedule_id IN (' . $exam_schedule_ids . ')')
				->where('is_deleted', 'false')
				->get_compiled_select();
		// Get Prospective Students
		$this->db->select('x1.student_id, x4.registration_number, x4.full_name');
		$this->db->join('admission_subject_setting_details x2', 'x1.subject_setting_detail_id = x2.id', 'LEFT');
		$this->db->join('admission_subject_settings x3', 'x2.subject_setting_id = x3.id', 'LEFT');
		$this->db->join('users x4', 'x1.student_id = x4.id', 'LEFT');
		$this->db->where('x1.is_deleted', 'false');
		$this->db->where('x2.is_deleted', 'false');
		$this->db->where('x3.is_deleted', 'false');
		$this->db->where('x3.subject_type', 'exam_schedule');
		$this->db->where('x4.re_registration', 'true');
		$this->db->where('x1.student_id NOT IN ( ' . $student_ids . ')');
		$this->db->group_by(['x1.student_id', 'x4.registration_number', 'x4.full_name']);
		return $this->db->get('admission_subject_scores x1');
	}
}
