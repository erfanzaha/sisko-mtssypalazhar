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

class M_admission_subject_settings extends CI_Model {

	/**
	 * Primary key
	 * @var String
	 */
	public static $pk = 'id';

	/**
	 * Table
	 * @var String
	 */
	public static $table = 'admission_subject_settings';

	/**
	 * Get Data
	 * @param String $keyword
	 * @param String $subject_type
	 * @param String $return_type
	 * @param Integer $limit
	 * @param Integer $offset
	 * @return Resource
	 */
	public function get_where($keyword = '', $subject_type = 'semester_report', $return_type = 'count', $limit = 0, $offset = 0) {
		$fields = ['x1.id', 'x2.academic_year', 'x3.option_name AS admission_type', 'x1.is_deleted'];
		if (__session('major_count') > 0) {
			array_push($fields, "COALESCE(x4.major_name, '-') AS major_name");
		}
		$this->db->select(implode(', ', $fields));
		$this->db->join('academic_years x2', 'x1.academic_year_id = x2.id', 'LEFT');
		$this->db->join('options x3', 'x1.admission_type_id = x3.id', 'LEFT');
		if (__session('major_count') > 0) {
			$this->db->join('majors x4', 'x1.major_id = x4.id', 'LEFT');
		}
		$this->db->where('x1.subject_type', $subject_type); // Nilai Rapor Sekolah
		if ( ! empty($keyword) ) {
			$this->db->group_start();
			$this->db->like('x2.academic_year', $keyword);
			$this->db->or_like('x3.option_name', $keyword);
			if (__session('major_count') > 0) {
				$this->db->or_like('x4.major_name', $keyword);
			}
			$this->db->group_end();
		}
		if ( $return_type === 'count' ) return $this->db->count_all_results(self::$table . ' x1');
		if ( $limit > 0 ) $this->db->limit($limit, $offset);
		return $this->db->get(self::$table . ' x1');
	}

	/**
	 * Get Subject Settings
	 * @param Integer $admission_type_id
	 * @param Integer $major_id
	 * @param String $subject_type
	 * @param String $visibility
	 * @return Array
	 */
	public function get_subject_settings($admission_type_id, $major_id = 0, $subject_type = 'semester_report', $visibility = '') {
		$data = [];
		$this->db->select('id');
		$this->db->where('academic_year_id', __session('admission_semester_id'));
		$this->db->where('admission_type_id', $admission_type_id);
		$this->db->where('major_id', $major_id);
		$this->db->where('subject_type', $subject_type);
		$this->db->where('is_deleted', 'false');
		$this->db->limit(1);
		$query = $this->db->get(self::$table);
		if ($query->num_rows() === 1) {
			$res = $query->row();
			$this->db->select('x1.id, x2.subject_name');
			$this->db->join('subjects x2', 'x1.subject_id = x2.id', 'LEFT');
			$this->db->where('x1.subject_setting_id', $res->id);
			$this->db->where('x1.is_deleted', 'false');
			// Jika Private, hanya diisi dari administrator saja
			if ($visibility == 'public') $this->db->where('x1.visibility', 'public');
			$subjects = $this->db->get('admission_subject_setting_details x1');
			foreach ($subjects->result() as $subject) {
				$data[] = [
					'subject_setting_detail_id' => $subject->id,
					'subject_name' => $subject->subject_name
				];
			}
		}
		return $data;
	}
}
