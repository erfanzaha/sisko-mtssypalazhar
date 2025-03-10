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

class M_verification_subject_scores extends CI_Model {

	/**
	 * Primary key
	 * @var String
	 */
	public static $pk = 'id';

	/**
	 * Table
	 * @var String
	 */
	public static $table = 'admission_subject_scores';
	
	/**
	 * Get Data
	 * @param String $keyword
	 * @param String $return_type
	 * @param Integer $limit
	 * @param Integer $offset
	 * @return Resource
	 */
	public function get_where($keyword = '', $return_type = 'count', $limit = 0, $offset = 0) {
		$this->db->select('
			x1.id
			, x5.registration_number
			, LEFT(x5.created_at, 10) AS created_at
			, x5.full_name
			, x3.subject_name
			, x4.subject_type
			, x1.score
			, x1.is_deleted
		');
		$this->db->join('admission_subject_setting_details x2', 'x1.subject_setting_detail_id = x2.id', 'LEFT');
		$this->db->join('subjects x3', 'x2.subject_id = x3.id', 'LEFT');
		$this->db->join('admission_subject_settings x4', 'x2.subject_setting_id = x4.id', 'LEFT');
		$this->db->join('users x5', 'x1.student_id = x5.id', 'LEFT');
		if ( ! empty($keyword) ) {
			$this->db->like('x5.registration_number', $keyword);
			$this->db->or_like('x5.created_at', $keyword);
			$this->db->or_like('x5.full_name', $keyword);
			$this->db->or_like('x3.subject_name', $keyword);
			$this->db->or_like('x4.subject_type', $keyword);
			$this->db->or_like('x1.score', $keyword);
		}
		$this->db->order_by('x5.registration_number', 'ASC');
		if ( $return_type === 'count' ) return $this->db->count_all_results(self::$table . ' x1');
		if ( $limit > 0 ) $this->db->limit($limit, $offset);
		return $this->db->get(self::$table . ' x1');
	}

	/**
	 * Get Subject Scores
	 * @param String $registration_number
	 * @param String $birth_date
	 * @return Array
	 */
	public function get_subject_scores($registration_number, $birth_date) {
		$this->db->select('x3.subject_name, x4.subject_type, x1.score');
		$this->db->join('admission_subject_setting_details x2', 'x1.subject_setting_detail_id = x2.id', 'LEFT');
		$this->db->join('subjects x3', 'x2.subject_id = x3.id', 'LEFT');
		$this->db->join('admission_subject_settings x4', 'x2.subject_setting_id = x4.id', 'LEFT');
		$this->db->join('users x5', 'x1.student_id = x5.id', 'LEFT');
		$this->db->where('x5.registration_number', $registration_number);
		$this->db->where('x5.birth_date', $birth_date);
		$this->db->where('x1.is_deleted', 'false');
		$this->db->where('x2.is_deleted', 'false');
		$this->db->where('x3.is_deleted', 'false');
		$this->db->where('x4.is_deleted', 'false');
		$this->db->where('x5.is_deleted', 'false');
		$query = $this->db->get(self::$table.' x1');
		$data = [];
		foreach($query->result() as $row) {
			$data[] = [
				'subject_name' => $row->subject_name,
				'subject_type' => $row->subject_type,
				'score' => $row->score
			];
		}
		return $data;
	}

	/**
	 * Get Student Subject Scores
	 * @param Integer $student_id
	 * @return Resource
	 */
	public function student_subject_scores($student_id = 0) {
		$this->db->select('
			x1.id
			, x5.registration_number
			, LEFT(x5.created_at, 10) AS created_at
			, x5.full_name
			, x3.subject_name
			, x4.subject_type
			, x1.score
			, x1.is_deleted
		');
		$this->db->join('admission_subject_setting_details x2', 'x1.subject_setting_detail_id = x2.id', 'LEFT');
		$this->db->join('subjects x3', 'x2.subject_id = x3.id', 'LEFT');
		$this->db->join('admission_subject_settings x4', 'x2.subject_setting_id = x4.id', 'LEFT');
		$this->db->join('users x5', 'x1.student_id = x5.id', 'LEFT');
		$this->db->where('x5.id', $student_id);
		$this->db->order_by('x4.subject_type', 'DESC');
		return $this->db->get(self::$table . ' x1');
	}
}
