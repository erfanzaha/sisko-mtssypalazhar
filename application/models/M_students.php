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

class M_students extends CI_Model {

	/**
	 * Primary key
	 * @var String
	 */
	public static $pk = 'id';

	/**
	 * Table
	 * @var String
	 */
	public static $table = 'users';
	
	/**
	 * Get Data
	 * @param String $keyword
	 * @param String $return_type
	 * @param Integer $limit
	 * @param Integer $offset
	 * @return Resource
	 */
	public function get_where($keyword = '', $return_type = 'count', $limit = 0, $offset = 0) {
		$this->db->select("
			x1.id
			, COALESCE(x1.nis, '') nis
			, x1.full_name
			, x2.option_name AS student_status
			, x1.gender
			, COALESCE(x1.birth_place, '') birth_place
			, x1.birth_date
			, x1.photo
			, x1.email
			, x1.is_deleted
			");
		$this->db->join('options x2', 'x1.student_status_id = x2.id', 'LEFT');
		$this->db->where('x1.is_student', 'true');
		$this->db->where('x1.is_alumni', 'false');
		if ( ! empty($keyword) ) {
			$this->db->group_start();
			$this->db->like('x1.nis', $keyword);
			$this->db->or_like('x2.option_name', $keyword);
			$this->db->or_like('x1.full_name', $keyword);
			$this->db->or_like('x1.gender', $keyword);
			$this->db->or_like('x1.birth_place', $keyword);
			$this->db->or_like('x1.birth_date', $keyword);
			$this->db->group_end();
		}
		if ( $return_type === 'count' ) return $this->db->count_all_results(self::$table . ' x1');
		if ( $limit > 0 ) $this->db->limit($limit, $offset);
		return $this->db->get(self::$table . ' x1');
	}

	/**
	 * Chart by Student Status
	 * @param Integer $academic_year_id
	 * @return Array
	 */
	public function chart_by_student_status($academic_year_id) {
		// Sub Query
		$this->db->select('x1.student_id');
		$this->db->join('class_group_settings x2', 'x1.class_group_setting_id = x2.id', 'LEFT');
		$this->db->where('x2.academic_year_id', _toInteger($academic_year_id));
		$this->db->group_by('x1.student_id');
		$student_ids = $this->db->get_compiled_select('class_group_students x1');
		// Query
		$this->db->select('x2.option_name AS labels, COUNT(*) AS data');
		$this->db->join('options x2', 'ON x1.student_status_id = x2.id', 'LEFT');
		$this->db->where('x1.is_student', 'true');
		$this->db->where('x1.is_alumni', 'false');
		$this->db->where('x1.id IN (' . $student_ids . ')');
		$this->db->group_by('x2.option_name');
		$this->db->order_by('x2.option_name', 'ASC');
		return $this->db->get('users x1');
	}

	/**
	 * Chart by Class Group
	 * @param Integer $academic_year_id
	 * @return Array
	 */
	public function chart_by_class_groups($academic_year_id) {
		return $this->db->query("
			SELECT CONCAT(x3.class_group, IF((x4.major_short_name <> ''), CONCAT(' ', x4.major_short_name),''),IF((x3.sub_class_group <> ''),CONCAT(' - ',x3.sub_class_group),'')) AS labels
				, COUNT(*) AS data
			FROM class_group_students x1
			LEFT JOIN class_group_settings x2
				ON x1.class_group_setting_id = x2.id
			LEFT JOIN class_groups x3
				ON x2.class_group_id = x3.id
			LEFT JOIN majors x4
				ON x3.major_id = x4.id
			WHERE x2.academic_year_id = ?
			GROUP BY 1
		", [_toInteger($academic_year_id)]);
	}

	/**
	 * Chart by End Date
	 * @return Array
	 */
	public function chart_by_end_date() {
		return $this->db->query("
			SELECT LEFT(x1.end_date, 4) AS labels
				, COUNT(*) AS data
			FROM users x1
			WHERE x1.is_alumni='true'
			AND x1.is_deleted='false'
			GROUP BY 1
			ORDER BY 1 ASC
		");
	}

	/**
	 * Update student to Alumni
	 * @param Array $ids
	 * @param String $end_date
	 * @return Boolean
	 */
	public function set_as_alumni($ids, $end_date) {
		$student_status_id = get_option_id('student_status', 'lulus');
		$dataset = [];
		$dataset['is_alumni'] = 'true';
		$dataset['end_date'] = $end_date.'-05-01';
		if ($student_status_id > 0) {
			$dataset['student_status_id'] = $student_status_id;
		}
		return $this->db
			->where_in('id', $ids)
			->update(self::$table, $dataset);
	}

	/**
	 * Student Reports
	 * @return Resource
	 */
	public function student_reports() {
		$query = $this->student_query();
		$query .= "
		AND x1.is_student='true'
		AND x1.is_alumni='false'
		ORDER BY x1.nis, x1.full_name ASC";
		return $this->db->query($query);
	}

	/**
	 * Student Query
	 * @return String
	 */
	public function student_query() {
		return "
			SELECT x1.*
				, x2.major_name
				, x3.major_name AS first_choice
				, x4.major_name AS second_choice
				, CASE WHEN x1.selection_result IS NULL THEN 'Belum Diseleksi'
					WHEN x1.selection_result = 'approved' THEN 'Diterima'
					WHEN x1.selection_result = 'unapproved' THEN 'Tidak Diterima'
					WHEN x1.selection_result > 0 THEN (SELECT major_name FROM majors WHERE id = x1.selection_result)
					ELSE '-'
					END AS selection_result
				, x5.phase_name
				, x6.option_name AS admission_type
				, IF(x1.is_transfer = 'true', 'Pindahan', 'Baru') AS is_transfer
				, IF(x1.re_registration = 'true', 'Ya', 'Tidak') AS re_registration
				, IF(x1.gender = 'M', 'Laki-laki', 'Perempuan') AS gender
				, x7.option_name AS religion
				, x8.option_name AS special_need
				, x9.option_name AS residence
				, x10.option_name AS transportation
				, x11.option_name AS father_education
				, x12.option_name AS father_employment
				, x13.option_name AS father_monthly_income
				, x14.option_name AS father_special_need
				, x15.option_name AS mother_education
				, x16.option_name AS mother_employment
				, x17.option_name AS mother_monthly_income
				, x18.option_name AS mother_special_need
				, x19.option_name AS guardian_education
				, x20.option_name AS guardian_employment
				, x21.option_name AS guardian_monthly_income
				, x22.option_name AS student_status
				, x23.option_name AS student_employment
			FROM users x1
			LEFT JOIN majors x2 ON x1.major_id = x2.id
			LEFT JOIN majors x3 ON x1.first_choice_id = x3.id
			LEFT JOIN majors x4 ON x1.second_choice_id = x4.id
			LEFT JOIN admission_phases x5 ON x1.admission_phase_id = x5.id
			LEFT JOIN options x6 ON x1.admission_type_id = x6.id
			LEFT JOIN options x7 ON x1.religion_id = x7.id
			LEFT JOIN options x8 ON x1.special_need_id = x8.id
			LEFT JOIN options x9 ON x1.residence_id = x9.id
			LEFT JOIN options x10 ON x1.transportation_id = x10.id
			LEFT JOIN options x11 ON x1.father_education_id = x11.id
			LEFT JOIN options x12 ON x1.father_employment_id = x12.id
			LEFT JOIN options x13 ON x1.father_monthly_income_id = x13.id
			LEFT JOIN options x14 ON x1.father_special_need_id = x14.id
			LEFT JOIN options x15 ON x1.mother_education_id = x15.id
			LEFT JOIN options x16 ON x1.mother_employment_id = x16.id
			LEFT JOIN options x17 ON x1.mother_monthly_income_id = x17.id
			LEFT JOIN options x18 ON x1.mother_special_need_id = x18.id
			LEFT JOIN options x19 ON x1.guardian_education_id = x19.id
			LEFT JOIN options x20 ON x1.guardian_employment_id = x20.id
			LEFT JOIN options x21 ON x1.guardian_monthly_income_id = x21.id
			LEFT JOIN options x22 ON x1.student_status_id = x22.id
			LEFT JOIN options x23 ON x1.employment_id = x23.id
			WHERE (
				is_student = 'true' 
				OR is_prospective_student = 'true'
				OR is_alumni = 'true'
			)
		";
	}

	/**
	 * Student Profile
	 * @param Integer $id
	 * @return Resource
	 */
	public function profile($id) {
		$query = $this->student_query();
		$query .= '
		AND x1.id = ?
		';
		return $this->db->query($query, [_toInteger($id)])->row();
	}
}