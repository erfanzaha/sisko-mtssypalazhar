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

class M_admission_exam_schedule_details extends CI_Model {

	/**
	 * Primary key
	 * @var String
	 */
	public static $pk = 'id';

	/**
	 * Table
	 * @var String
	 */
	public static $table = 'admission_exam_schedules';

	/**
	 * Get Data
	 * @param String $keyword
	 * @param Integer $subject_setting_detail_id
	 * @param String $return_type
	 * @param Integer $limit
	 * @param Integer $offset
	 * @return Resource
	 */
	public function get_where($keyword = '', $subject_setting_detail_id = 0, $return_type = 'count', $limit = 0, $offset = 0) {
		$this->db->select('x1.id, x2.room_name, x2.room_capacity, x3.option_name AS building_name, x1.exam_date, x1.exam_start_time, x1.exam_end_time, x1.is_deleted');
		$this->db->join('rooms x2', 'x1.room_id = x2.id', 'LEFT');
		$this->db->join('options x3', 'x2.building_id = x3.id', 'LEFT');
		$this->db->where('x1.subject_setting_detail_id', $subject_setting_detail_id);
		if ( ! empty($keyword) ) {
			$this->db->group_start();
			$this->db->like('x1.exam_date', $keyword);
			$this->db->or_like('x1.exam_start_time', $keyword);
			$this->db->or_like('x1.exam_end_time', $keyword);
			$this->db->or_like('x2.room_name', $keyword);
			$this->db->or_like('x2.room_capacity', $keyword);
			$this->db->or_like('x3.option_name', $keyword);
			$this->db->group_end();
		}
		if ( $return_type === 'count' ) return $this->db->count_all_results(self::$table . ' x1');
		if ( $limit > 0 ) $this->db->limit($limit, $offset);
		return $this->db->get(self::$table . ' x1');
	}

	/**
	 * Get Title
	 * @param Integer id
	 * @return Object
	 */
	public function get_title($id) {
		$fields = [
			'x1.id'
			, 'x1.exam_date'
			, 'x1.exam_start_time'
			, 'x1.exam_end_time'
			, 'x2.id AS room_id'
			, 'x2.room_name'
			, 'x2.room_capacity'
			, 'x3.id AS building_id'
			, 'x3.option_name AS building_name'
			, 'x5.id AS subject_id'
			, 'x5.subject_name'
			, 'x7.id AS academic_year_id'
			, 'x7.academic_year'
			, 'x8.id AS admission_type_id'
			, 'x8.option_name AS admission_type'
		];
		if (__session('major_count') > 0) {
			array_push($fields, 'x9.id AS major_id', "COALESCE(x9.major_name, '-') AS major_name");
		}
		$this->db->select(implode(', ', $fields));
		$this->db->join('rooms x2', 'x1.room_id = x2.id');
		$this->db->join('options x3', 'x2.building_id = x3.id');
		$this->db->join('admission_subject_setting_details x4', 'x1.subject_setting_detail_id = x4.id');
		$this->db->join('subjects x5', 'x4.subject_id = x5.id');
		$this->db->join('admission_subject_settings x6', 'x4.subject_setting_id = x6.id');
		$this->db->join('academic_years x7', 'x6.academic_year_id = x7.id');
		$this->db->join('options x8', 'x6.admission_type_id = x8.id');
		if (__session('major_count') > 0) {
			$this->db->join('majors x9', 'x6.major_id = x9.id', 'LEFT');
		}
		$this->db->where('x1.id', $id);
		$query = $this->db->get('admission_exam_schedules x1');
		if ($query->num_rows() === 1) {
			return $query->row();
		}
		return NULL;
	}

	/**
	 * Exam Schedule by Student ID
	 * @param Integer $student_id
	 * @return Resource
	 */
	public function get_student_exam_schedules($student_id = 0) {
		return $this->db
			->select('x2.exam_date, x2.exam_start_time, x2.exam_end_time, x6.subject_name, x4.option_name AS building_name, x3.room_name')
			->join('admission_exam_schedules x2', 'x1.exam_schedule_id = x2.id', 'LEFT')
			->join('rooms x3', 'x2.room_id = x3.id', 'LEFT')
			->join('options x4', 'x3.building_id = x4.id', 'LEFT')
			->join('admission_subject_setting_details x5', 'x2.subject_setting_detail_id = x5.id', 'LEFT')
			->join('subjects x6', 'x5.subject_id = x6.id', 'LEFT')
			->where('x1.student_id', _toInteger($student_id))
			->where('x1.is_deleted', 'false')
			->where('x2.is_deleted', 'false')
			->where('x3.is_deleted', 'false')
			->where('x4.is_deleted', 'false')
			->where('x5.is_deleted', 'false')
			->where('x6.is_deleted', 'false')
			->order_by('x2.exam_date', 'ASC')
			->order_by('x2.exam_start_time', 'ASC')
			->get('admission_exam_attendances x1');
	}
}
